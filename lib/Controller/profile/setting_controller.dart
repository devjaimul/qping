import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class SettingController extends GetxController {

  var appContent = ''.obs;
  var isLoadingAppData = false.obs;

  Future<void> fetchAppData(String type) async {
    isLoadingAppData.value = true;
    try {
      final response = await ApiClient.getData(Urls.appData(type));
      if (response.statusCode == 200) {

        appContent.value = response.body['data']['content'] ?? '';
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to fetch App Data");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingAppData.value = false;
    }
  }
}
