import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/services/socket_services.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageChatController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  static const int limit = 10;
  RxBool isLoadingMessages = false.obs;
  String? myUserId;
  var isInInbox = true.obs; // Make it observable

  void setMyUserId(String id) {
    myUserId = id;
  }

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

        List<Map<String, dynamic>> newMessages = (data as List).map((msg) {
          return {
            'type': msg['attachments'] != null &&
                (msg['attachments'] as List).isNotEmpty
                ? 'image'
                : 'text',
            'content': msg['attachments'] != null &&
                (msg['attachments'] as List).isNotEmpty
                ? msg['attachments'][0]['fileUrl']
                : msg['content'],
            'isSentByMe': myUserId != null ? (msg['sender'] == myUserId) : false,
            'time': DateFormat('h.mm a')
                .format(DateTime.parse(msg['createdAt']).toLocal()),
          };
        }).toList();

        messages.addAll(newMessages);
        totalPages.value = pagination['totalPages'];
        currentPage.value = pagination['currentPage'] + 1;
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to retrieve messages");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  void initSocketAndJoinConversation(String conversationId, senderName) {

    SocketServices.socket.off('conversation-$conversationId');
    SocketServices.emit('join', {
      'groupId': conversationId,
    });

    listenForIncomingMessages(conversationId, senderName);
  }


  void listenForIncomingMessages(String conversationId, senderName) {
    SocketServices.socket.on('conversation-$conversationId', (data) {
      if (data != null) {
        final bool isSentByMe = data['sender'] == myUserId;
        final String messageType = data['type'] ?? 'text';
        final String content = data['content'] ?? '';

        messages.insert(0, {
          'type': messageType == 'image' ? 'image' : 'text',
          'content': content,
          'isSentByMe': isSentByMe,
          'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
        });

        // If not in inbox, show notification
        print("hlegb================================${isInInbox.value}");
        if (isInInbox.value) {

          _showNotification(
            "$senderName",
            content,
          );
        }
      }
    });
  }

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

  void sendMessageToSocket(String conversationId, String content, {String type = 'individual'}) {
    final body = {
      'groupId': conversationId,
      'content': content,
      'messageOn': type,
    };

    SocketServices.emit('send-message', body);
  }
}
