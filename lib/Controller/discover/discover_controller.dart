import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class DiscoverScreenController extends GetxController {
  // Holds the list of groups fetched from the server
  RxList<Map<String, dynamic>> groupList = <Map<String, dynamic>>[].obs;

  // Pagination properties
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  static const int limit = 10;

  var isLoading = false.obs;
  var searchQuery = ''.obs; // For searching groups

  @override
  void onInit() {
    super.onInit();
    fetchGroupList(isRefresh: true);
  }

  // Fetch groups from the API
  Future<void> fetchGroupList({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      groupList.clear();
      totalPages.value = 1;
    }

    // No need to fetch if we've already loaded all pages
    if (currentPage.value > totalPages.value) {
      return;
    }

    isLoading.value = true;

    final response = await ApiClient.getData(
      Urls.showGroupList(
        currentPage.value.toString(),
        limit.toString(),
        searchQuery.value,
        "no", // 'involved' param for groups the user is not in
      ),
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      var responseBody = response.body;

      if (responseBody['ok'] == true) {
        // Update pagination info
        final pagination = responseBody['pagination'];
        if (pagination != null) {
          totalPages.value = pagination['totalPages'] ?? 1;
          currentPage.value = (pagination['currentPage'] as int) + 1;
        }

        // Parse the data
        final data = responseBody['data'];
        if (data is List) {

          groupList.addAll(
            data.map((group) {
              return {
                '_id': group['_id'],
                'name': group['name'],
                'avatar': group['avatar'],
                'description': group['description'] ?? '',
                'type': group['type'] ?? 'public',
                'totalMember': group['totalMember']?.toString() ?? '0',
              };
            }).toList(),
          );
        }
      }
    } else {

    }
  }

  // Trigger search
  void searchGroups(String value) {
    searchQuery.value = value;
    fetchGroupList(isRefresh: true);
  }

  /// Join a public group by ID
  Future<void> joinGroup(String groupId) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.postData(
        Urls.joinPublicGroup(groupId),
        {},
      );
      isLoading.value = false;

      if (response.statusCode == 200) {

        Get.snackbar("Success", "Joined group successfully!");


        await fetchGroupList(isRefresh: true);

      } else {

        Get.snackbar("Error", response.body['message'] ?? "Failed to join group.");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }
}
