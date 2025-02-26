import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  // Fetch notifications from the API
  Future<void> fetchNotifications() async {
    if (isLoading.value) return;

    isLoading.value = true;

    final response = await ApiClient.getData(
      Urls.notification(currentPage.value.toString(), '10'),
    );

    if (response.statusCode == 200) {
      var data = response.body['data'] as List;
      var pagination = response.body['pagination'];

      List<Map<String, dynamic>> notificationList = data
          .map((item) => item as Map<String, dynamic>)
          .toList();

      notifications.addAll(notificationList);
      currentPage.value = pagination['currentPage'] + 1;
      totalPages.value = pagination['totalPages'];
    } else {

    }

    isLoading.value = false;
  }
}
