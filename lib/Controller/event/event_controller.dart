import 'package:get/get.dart';
import 'package:qping/routes/app_routes.dart';
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

  // Create event with POST request
  Future<void> createEvent({
    required String eventName,
    required String eventDescription,
    required String eventTime,
    required String eventDate,
    required String eventLocation,
  }) async {
    isLoading.value = true;

    final response = await ApiClient.postData(
      Urls.createEvents,
      {
        "eventName": eventName,
        "eventDescription": eventDescription,
        "eventTime": eventTime,
        "eventDate": eventDate,
        "eventLocation": eventLocation,
      },
    );

    if (response.statusCode == 200) {
      print("Event created successfully!");
      // Optionally, you can call fetchEvents again to update the list.
      fetchEvents(page: currentPage.value, limit: 10);
    } else {
      print('Error creating event: ${response.statusText}');
    }

    isLoading.value = false;
  }

  Future<void> updateEvent({
    required String eventName,
    required String eventId,
    required String eventDescription,
    required String eventTime,
    required String eventDate,
    required String eventLocation,
  }) async {
    isLoading.value = true;

    final response = await ApiClient.patch(
      Urls.updateEvents(eventId),
      {
        "eventName": eventName,
        "eventDescription": eventDescription,
        "eventTime": eventTime,
        "eventDate": eventDate,
        "eventLocation": eventLocation,
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Event Updated Successfully.");
    } else {
      print('Error creating event: ${response.statusText}');
    }

    isLoading.value = false;
  }

  // Delete event with DELETE request
  Future<void> deleteEvent(String eventId) async {
    isLoading.value = true;

    final response = await ApiClient.deleteData(Urls.deleteEvents(eventId));

    if (response.statusCode == 200) {
      fetchEvents(page: currentPage.value, limit: 10);


      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
        Get.snackbar("Success", "Event deleted successfully!");
      });
    } else {
      print('Error deleting event: ${response.statusText}');
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

}
