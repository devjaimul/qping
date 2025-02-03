import 'package:get/get.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class ResetPassController extends GetxController {
  final isLoading = false.obs;

  Future<void> changePassword(String password, String confirmPassword) async {
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match.");
      return;
    }

    isLoading.value = true;

    final body = {
      "password": password,
      "confirmPassword": confirmPassword,
    };

    try {
      final response = await ApiClient.postData(
        Urls.forgetPass,
        body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message'] ?? "Password Updated Successfully!");
        Get.offAllNamed(AppRoutes.signInScreen);
      } else {
        final errorMessage = response.body['message'] ?? "Failed to update password.";
        Get.snackbar("Error", errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
