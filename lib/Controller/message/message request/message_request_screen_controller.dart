import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';
import 'package:qping/views/bottom%20nav%20bar/custom_nav_bar.dart';

class MessageRequestController extends GetxController{
  final chatData = <dynamic>[].obs;
  final requestData = <dynamic>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  static const int limit = 10;
  var searchQuery = ''.obs;

  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxInt currentPageMsg = 1.obs; // Dedicated pagination for messages
  RxInt totalPagesMsg = 1.obs;
  RxBool isLoadingMessages = false.obs;
  @override
  void onInit() {
    super.onInit();
    // Debounce search input so that the API call is triggered only after 500ms of no changes
    debounce(searchQuery, (_) {
      // Refresh list when search query stops changing
      getPendingChatList(isRefresh: true, type: 'pending');
    }, time: const Duration(milliseconds: 500));
  }
  //get message request chats list
  Future<void> getPendingChatList({bool isRefresh = false, required String type}) async {
    if (isRefresh) {
      currentPage.value = 1;
      totalPages.value = 1;
      chatData.clear();
    }
    isLoading.value = true;
    // Build the API URL with page, limit, type, and search parameters
    final response = await ApiClient.getData(
      Urls.getChatList(
        currentPage.value.toString(),
        limit.toString(),
        type,
        searchQuery.value, // uses current search query
      ),
    );
    isLoading.value = false;

    if (response.statusCode == 200) {
      var data = response.body['data'];
      if (data is List) {
        chatData.addAll(data);
      }
      var pagination = response.body['pagination'];
      totalPages.value = pagination['totalPages'] ?? 1;
      currentPage.value++;
    } else {
      Get.snackbar("Error", response.body['message'] ?? "Failed to load chat list.");
    }
  }



  //get message request chats message
  Future<void> fetchChatMessages(String conversationId,
      {String type = 'individual', bool refresh = false}) async {
    if (refresh) {
      currentPageMsg.value = 1;
      totalPagesMsg.value = 1;
      messages.clear();
    }

    if (currentPageMsg.value > totalPagesMsg.value && currentPageMsg.value != 1) return;

    isLoadingMessages.value = true;
    try {
      final response = await ApiClient.getData(
        Urls.chatMsgList(
          currentPageMsg.value.toString(),
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
            'id': msg['_id'],
            'sender': msg['sender'],
            'content': msg['content'],
            'attachments': msg['attachments'],
            'type': (msg['attachments'] != null &&
                (msg['attachments'] as List).isNotEmpty)
                ? 'image'
                : 'text',
            // Format the creation time
            'time': DateFormat('h.mm a')
                .format(DateTime.parse(msg['createdAt']).toLocal()),
            'isSentByMe': false,
          };
        }).toList();

        messages.addAll(newMessages);
        totalPagesMsg.value = pagination['totalPages'] ?? 1;
        currentPageMsg.value = pagination['currentPage'] + 1;
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to retrieve messages");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  //accept request chat message

  Future<void> acceptRequestChat (String conversationId) async {
    try {
      final response = await ApiClient.postData(
        Urls.acceptChatRequest(conversationId),
        {},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message']);
        Get.offAll(()=>const CustomNavBar());
      } else {
        Get.snackbar("!!!!!", response.body['message'] ?? "Failed.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }
  // Delete request chat message
  Future<void> deleteRequest (String conversationId) async {
    try {
      final response = await ApiClient.postData(
        Urls.deleteRequest(conversationId),
        {},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message']);
        Get.offAll(()=>const CustomNavBar());
      } else {
        Get.snackbar("!!!!!", response.body['message'] ?? "Failed.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }


  void markAsRead(int index) {
    chatData[index]['isUnread'] = false;
    chatData.refresh();
  }
}
