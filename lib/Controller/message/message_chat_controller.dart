import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class MessageChatController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // Pagination properties
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  static const int limit = 10;
  RxBool isLoadingMessages = false.obs;

  // Store your user id for determining if a message is sent by you
  String? myUserId;
  void setMyUserId(String id) {
    myUserId = id;
  }

  void addTextMessage(String content) {
    messages.add({
      'type': 'text',
      'content': content,
      'isSentByMe': true,
      'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
    });
  }

  void addImageMessage(String path) {
    messages.add({
      'type': 'image',
      'content': path,
      'isSentByMe': true,
      'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
    });
  }

  // New method to fetch chat messages with pagination support
  Future<void> fetchChatMessages(String conversationId,
      {String type = 'individual', bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      messages.clear();
    }
    // If there are no more pages, do nothing
    if (currentPage.value > totalPages.value && currentPage.value != 1) return;

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

        // Map API messages into your local format.
        // "isSentByMe" is determined by comparing msg['sender'] with myUserId.
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

        // Append the newly fetched messages
        messages.addAll(newMessages);
        totalPages.value = pagination['totalPages'];
        currentPage.value = pagination['currentPage'] + 1;
      } else {
        Get.snackbar("Error",
            response.body['message'] ?? "Failed to retrieve messages");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }
}
