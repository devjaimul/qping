import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class EventController extends GetxController {
  var events = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  // Fetch events from the API with pagination
  Future<void> fetchEvents({int page = 1, int limit = 10}) async {
    if (isLoading.value || page > totalPages.value) return;

    isLoading.value = true;

    final response = await ApiClient.getData(Urls.getEvents(page.toString(), limit.toString()));

    if (response.statusCode == 200) {
      var data = response.body['data'] as List;
      var pagination = response.body['pagination'];

      if (pagination != null) {
        // Safe check to ensure pagination exists
        currentPage.value = pagination['currentPage'] ?? 1;
        totalPages.value = pagination['totalPages'] ?? 1;
      }

      if (page == 1) {
        events.value = data.map((event) => event as Map<String, dynamic>).toList();
      } else {
        events.addAll(data.map((event) => event as Map<String, dynamic>).toList());
      }
    } else {
      print('Error fetching events: ${response.statusText}');
    }

    isLoading.value = false;
  }


  Future<void> joinEvent(String eventId) async {
    try {
      final response = await ApiClient.postData(
        Urls.joinEvents(eventId),
        {},
      );

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar("Success", response.body['message']);
        fetchEvents();
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  // Fetch joined events from the API with pagination
  Future<void> fetchJoinedEvents({int page = 1, int limit = 10}) async {
    if (isLoading.value || page > totalPages.value) return;

    isLoading.value = true;

    final response = await ApiClient.getData(Urls.joinedEvents(page.toString(), limit.toString()));

    if (response.statusCode == 200) {
      var data = response.body['data'] as List;
      var pagination = response.body['pagination'];

      if (pagination != null) {
        // Safe check to ensure pagination exists
        currentPage.value = pagination['currentPage'] ?? 1;
        totalPages.value = pagination['totalPages'] ?? 1;
      }

      if (page == 1) {
        events.value = data.map((event) => event as Map<String, dynamic>).toList();
      } else {
        events.addAll(data.map((event) => event as Map<String, dynamic>).toList());
      }
    } else {
      print('Error fetching joined events: ${response.statusText}');
    }

    isLoading.value = false;
  }
}
