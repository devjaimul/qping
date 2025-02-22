import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class MessageRequestController extends GetxController{
  final chatData = <dynamic>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  static const int limit = 10;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initially load the list
    //getPendingChatList(isRefresh: true, type: 'pending');

    // Debounce search input so that the API call is triggered only after 500ms of no changes
    debounce(searchQuery, (_) {
      // Refresh list when search query stops changing
      getPendingChatList(isRefresh: true, type: 'pending');
    }, time: const Duration(milliseconds: 500));
  }

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

  void markAsRead(int index) {
    chatData[index]['isUnread'] = false;
    chatData.refresh();
  }
}
