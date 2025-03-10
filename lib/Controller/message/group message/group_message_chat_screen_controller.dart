import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/services/socket_services.dart';
import 'package:qping/utils/urls.dart';

class GroupMessageChatScreenController extends GetxController {
  /// Holds the list of messages for this group
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> groupMetadata = <String, dynamic>{}.obs;

  /// Pagination tracking
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  static const int limit = 10;
  RxBool isLoadingMessages = false.obs;

  /// Flag to indicate if user is in the inbox or in this group chat screen
  var isInInbox = true.obs;

  /// Your user ID
  String? myUserId;

  /// Set user ID after fetching from preferences
  void setMyUserId(String id) {
    myUserId = id;
  }

  /// Fetch group messages from your API
  Future<void> fetchGroupMessages(String groupId, {bool refresh = false, String type = 'group'}) async {
    if (refresh) {
      currentPage.value = 1;
      messages.clear();
    }

    if (currentPage.value > totalPages.value) return;

    isLoadingMessages.value = true;
    try {
      final response = await ApiClient.getData(
        Urls.chatMsgList(
          currentPage.value.toString(),
          limit.toString(),
          type,
          groupId,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.body['data'];
        var pagination = response.body['pagination'];

        var metadata = response.body['metadata'] ?? {};

        groupMetadata.value = Map<String, dynamic>.from(metadata);
      update();
        List<Map<String, dynamic>> newMessages = (data as List).map((msg) {
          return {
            // Distinguish text vs image
            'type': (msg['attachments'] != null && (msg['attachments'] as List).isNotEmpty)
                ? 'image'
                : msg['type'],


            // Actual content
            'content': (msg['attachments'] != null && (msg['attachments'] as List).isNotEmpty)
                ? msg['attachments'][0]['fileUrl']
                : msg['content'],

            // Check if sender is me
            'isSentByMe': (myUserId != null) ? (msg['sender'] == myUserId) : false,

            // Format time
            'time': DateFormat('h.mm a').format(
              DateTime.parse(msg['createdAt']).toLocal(),
            ),

            // Additional fields
            'senderName': msg['senderName'],
            'profilePicture': msg['profilePicture'],

            // For reaction updates
            'messageId': msg['_id'],
            // Store reactions if present, else empty map
            'reactions': (msg['reactions'] != null)
                ? Map<String, dynamic>.from(msg['reactions'])
                : <String, dynamic>{},
          };
        }).toList();

        // Append new messages
        messages.addAll(newMessages);

        // Update pagination
        totalPages.value = pagination['totalPages'] ?? 1;
        currentPage.value = (pagination['currentPage'] as int) + 1;
      } else {
        // Show error from server if any
        Get.snackbar("Error", response.body['message'] ?? "Failed to retrieve messages");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  /// Join the group room via socket
  void initSocketAndJoinGroup(String groupId, String groupName) {
    // Remove any previous listeners for this group
    SocketServices.socket.off('conversation-$groupId');
    SocketServices.socket.off('messageReactionUpdated');

    // Join the group
    SocketServices.emit('join', {
      'groupId': groupId,
    });

    listenForIncomingMessages(groupId, groupName);
  }

  /// Listen for new messages and reaction updates
  void listenForIncomingMessages(String groupId, String groupName) {
    // 1) Listen for new group messages
    SocketServices.socket.on('conversation-$groupId', (data) {
      if (data != null) {
        final bool isSentByMe = (data['sender'] == myUserId);
        final String messageType = data['type'] ?? 'text';

        // Get content
        String content = '';
        if (messageType == 'image') {
          if (data['attachments'] != null && (data['attachments'] as List).isNotEmpty) {
            content = data['attachments'][0]['fileUrl'];
          }
        } else {
          content = data['content'] ?? '';
        }

        final String senderName = data['senderName'] ?? '';
        final String profilePicture = data['profilePicture'] ?? '';

        // Insert the new message at index 0 (since reverse = true)
        messages.insert(0, {
          'type': messageType == 'image' ? 'image' : 'text',
          'content': content,
          'isSentByMe': isSentByMe,
          'senderName': senderName,
          'profilePicture': profilePicture,
          'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
          'messageId': data['_id'] ?? 'temp-id',
          'reactions': <String, dynamic>{},
        });

        // If user is in the inbox, show a local notification
        if (isInInbox.value && !isSentByMe) {
          _showNotification(groupName, messageType == 'image' ? "Sent an image" : content);
        }
      }
    });

    //  Listen for group reaction updates

    SocketServices.socket.on('messageReactionUpdated', (data) {
      if (data != null && data['messageId'] != null && data['reactions'] != null) {
        final String updatedMessageId = data['messageId'];
        final Map<String, dynamic> updatedReactions = Map<String, dynamic>.from(data['reactions']);

        // Find the message in local list
        final index = messages.indexWhere((m) => m['messageId'] == updatedMessageId);
        if (index >= 0) {
          messages[index]['reactions'] = updatedReactions;
          messages.refresh();
        }
      }
    });
  }

  /// Show local notification for group message
  Future<void> _showNotification(String title, String body) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'chat_channel',
        'Chat Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  /// Send a text message in a group
  void sendMessageToSocket(String groupId, String content, {String type = 'group'}) {
    final body = {
      'groupId': groupId,
      'content': content,
      'messageOn': type,
    };
    SocketServices.emit('send-message', body);
  }

  /// Send an image message in a group
  Future<void> sendImageMessage(String groupId, File? file) async {
    if (file == null) return;
    List<MultipartBody> multipartBody = [MultipartBody("files", file)];
    var body = {
      "conversationID": groupId,
      "messageOn": 'group',
      "files": '$file',
    };

    await ApiClient.postMultipartData(
      Urls.sendImage,
      body,
      multipartBody: multipartBody,
    );
  }

  /// React to a group message locally, then emit
  void reactToGroupMessage(int index, String reaction) {
    final messageId = messages[index]['messageId'];
    if (messageId == null) return;

    // Emit to server
    SocketServices.emit('reaction', {
      "messageId": messageId,
      "reactionType": reaction,
    });
  }
}
