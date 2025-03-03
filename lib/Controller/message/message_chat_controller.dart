import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/services/socket_services.dart';
import 'package:qping/utils/urls.dart';

class MessageChatController extends GetxController {
  /// List of messages in this conversation
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  /// Pagination & loading
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  static const int limit = 10;
  RxBool isLoadingMessages = false.obs;

  /// Track if user is actually in this chat screen
  var isInInbox = true.obs;

  /// Your user ID, set once you fetch from prefs
  String? myUserId;

  void setMyUserId(String id) {
    myUserId = id;
  }

  /// Fetch the chat messages from your API
  Future<void> fetchChatMessages(String conversationId,
      {String type = 'individual', bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      messages.clear();
    }

    if (currentPage.value > totalPages.value) {
      return;
    }

    isLoadingMessages.value = true;
    try {
      final response = await ApiClient.getData(
        Urls.chatMsgList(
          currentPage.value.toString(),
          limit.toString(),
          type,
          conversationId,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.body['data'];
        var pagination = response.body['pagination'];

        // Convert each message to our local format
        List<Map<String, dynamic>> newMessages = (data as List).map((msg) {
          return {
            // text or image
            'type': (msg['attachments'] != null && (msg['attachments'] as List).isNotEmpty)
                ? 'image'
                : 'text',

            // content => fileUrl if image, else 'content'
            'content': (msg['attachments'] != null && (msg['attachments'] as List).isNotEmpty)
                ? msg['attachments'][0]['fileUrl']
                : msg['content'],

            // Is the sender me?
            'isSentByMe': myUserId != null ? (msg['sender'] == myUserId) : false,

            // Formatted time
            'time': DateFormat('h.mm a').format(
              DateTime.parse(msg['createdAt']).toLocal(),
            ),

            // Keep the messageId for reaction updates
            'messageId': msg['_id'],

            // Store reactions map if present, else empty
            'reactions': (msg['reactions'] != null)
                ? Map<String, dynamic>.from(msg['reactions'])
                : <String, dynamic>{},
          };
        }).toList();

        messages.addAll(newMessages);

        // Update pagination
        totalPages.value = pagination['totalPages'];
        currentPage.value = pagination['currentPage'] + 1;
      } else {
        // Some error from server
        // e.g.  Get.snackbar("Error", response.body['message'] ?? "Failed to retrieve messages");
      }
    } catch (e) {
      // e.g. Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  /// Initialize socket and join conversation room
  void initSocketAndJoinConversation(String conversationId, String senderName) {
    // Remove old listeners for this conversation (avoid duplicates)
    SocketServices.socket.off('conversation-$conversationId');
    SocketServices.socket.off('messageReactionUpdated');

    // Join the conversation room
    SocketServices.emit('join', {
      'groupId': conversationId,
    });

    listenForIncomingMessages(conversationId, senderName);
  }

  /// Listen for new messages and reaction updates
  void listenForIncomingMessages(String conversationId, String senderName) {
    // When a new message arrives
    SocketServices.socket.on('conversation-$conversationId', (data) {
      if (data != null) {
        final bool isSentByMe = data['sender'] == myUserId;
        final String messageType = data['type'] ?? 'text';

        String content = '';
        if (messageType == 'image') {
          if (data['attachments'] != null && (data['attachments'] as List).isNotEmpty) {
            content = data['attachments'][0]['fileUrl'];
          }
        } else {
          content = data['content'] ?? '';
        }

        // Insert new message at the top (reverse list)
        messages.insert(0, {
          'type': messageType == 'image' ? 'image' : 'text',
          'content': content,
          'isSentByMe': isSentByMe,
          'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
          // For reactions, default to an empty map
          'reactions': <String, dynamic>{},
          'messageId': data['_id'] ?? 'temp-id',
        });

        // If user is not in the chat screen, show a local notification
        if (isInInbox.value) {
          _showNotification(
            "$senderName",
            messageType == 'image' ? "Sent an image" : content,
          );
        }
      }
    });

    // Listen for reaction updates from server
    // Make sure your backend emits this event with { messageId, reactions }
    SocketServices.socket.on('messageReactionUpdated', (data) {
      if (data != null && data['messageId'] != null && data['reactions'] != null) {
        final String updatedMessageId = data['messageId'];
        final Map<String, dynamic> updatedReactions =
        Map<String, dynamic>.from(data['reactions']);

        // Find the message in local list
        final index = messages.indexWhere((m) => m['messageId'] == updatedMessageId);
        if (index >= 0) {
          messages[index]['reactions'] = updatedReactions;
          messages.refresh();
        }
      }
    });
  }

  /// Show a local notification (only on Android in this snippet)
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

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  /// Send a text message
  void sendMessageToSocket(String conversationId, String content, {String type = 'individual'}) {
    final body = {
      'groupId': conversationId,
      'content': content,
      'messageOn': type,
    };
    SocketServices.emit('send-message', body);
  }

  /// Send an image message
  Future<void> sendMessageWithImage(String conversationID, File? file) async {
    if (file == null) return;

    // Using a custom postMultipartData method in your code
    final multipartBody = [MultipartBody("files", file)];
    final body = {
      "conversationID": conversationID,
      "messageOn": 'individual',
      "files": '$file',
    };
    await ApiClient.postMultipartData(
      Urls.sendImage,
      body,
      multipartBody: multipartBody,
    );
  }

  /// React to a message (client side)
  /// We'll do a quick local update, then emit to server
  void reactToMessage(int index, String reaction) {
    final messageId = messages[index]['messageId'];
    if (messageId == null) return;

    // Quick local increment for immediate feedback
    if (messages[index]['reactions'] == null) {
      messages[index]['reactions'] = <String, dynamic>{};
    }
    final oldVal = messages[index]['reactions'][reaction] ?? 0;
    messages[index]['reactions'][reaction] = oldVal + 1;
    messages.refresh();

    // Emit to server
    SocketServices.emit('reaction', {
      "messageId": messageId,
      "reactionType": reaction,
    });
  }
}
