import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class MessageController extends GetxController {
  final chatData = <dynamic>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  static const int limit = 10;
  var searchQuery = ''.obs; // Holds the search text

  @override
  void onInit() {
    super.onInit();

    // Debounce search input so that the API call is triggered only after 500ms of no changes
    debounce(searchQuery, (_) {
      getAcceptChatList(isRefresh: true, type: 'accepted');
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> getAcceptChatList({bool isRefresh = false, required String type}) async {
    if (isRefresh) {
      currentPage.value = 1;
      totalPages.value = 1;
      chatData.clear();
    }

    // If there are no more pages to load, return immediately.
    if (currentPage.value > totalPages.value) {
      return;
    }

    isLoading.value = true;
    // Build the API URL with page, limit, type, and search parameters
    final response = await ApiClient.getData(
      Urls.getChatList(
        currentPage.value.toString(),
        limit.toString(),
        type,
        searchQuery.value,
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


      if (pagination['nextPage'] != null) {
        currentPage.value = pagination['nextPage'];
      } else {
        currentPage.value = (pagination['currentPage'] as int) + 1;
      }
    } else {
      Get.snackbar("Error", response.body['message'] ?? "Failed to load chat list.");
    }
  }

  void markAsRead(int index) {
    chatData[index]['isUnread'] = false;
    chatData.refresh();
  }
}
