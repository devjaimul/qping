import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';


class GroupMessageController extends GetxController {
  var chatData = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  static const int limit = 10;

  @override
  void onInit() {
    fetchGroupList();
    super.onInit();
  }

  Future<void> fetchGroupList({bool isRefresh = false}) async {
    if (isRefresh) {
      /// Reset the pagination and data
      currentPage.value = 1;
      chatData.clear();
      totalPages.value = 1; // Reset total pages count
    }

    if (currentPage.value > totalPages.value) return;

    isLoading.value = true;

    final response = await ApiClient.getData(
      Urls.showGroupList(
        currentPage.value.toString(),
        limit.toString(),
        searchQuery.value,
      ),
    );

    if (response.statusCode == 200) {
      var responseBody = response.body;

      if (responseBody['ok'] == true) {
        totalPages.value = responseBody['pagination']['totalPages'];
        var groups = List<Map<String, dynamic>>.from(responseBody['data']);

        if (isRefresh) {
          chatData.assignAll(groups);
        } else {
          chatData.addAll(groups);
        }

        if (chatData.isEmpty && searchQuery.value.isNotEmpty) {
          chatData.clear();
        }

        currentPage.value++;
      }
    }

    isLoading.value = false;
  }


  void searchGroups(String value) {
    searchQuery.value = value;

    if (value.isEmpty) {
      fetchGroupList(isRefresh: true);
    } else {
      fetchGroupList(isRefresh: true);
    }
  }

}
