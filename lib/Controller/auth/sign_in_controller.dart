import 'package:get/get.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';

class SignInController extends GetxController {
  final isLoading = false.obs;

  Future<void> login(String email, String password) async {

    isLoading.value = true;

    final body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await ApiClient.postData(
        Urls.login,
        body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Extract required fields from the response
        final data = response.body['data'];
        final token = response.body['token'];
        final isEmailVerified = data['isEmailVerified'].toString();
        final isProfilePicture = data['profilePicture'] ?? '';
        final isProfileID = data['profileID'] ?? '';

        // Save these values in shared preferences
        await PrefsHelper.setString(AppConstants.bearerToken, token);
        await PrefsHelper.setString(AppConstants.isEmailVerified, isEmailVerified);
        await PrefsHelper.setString(AppConstants.isProfilePicture, isProfilePicture);
        await PrefsHelper.setString(AppConstants.isProfileID, isProfileID);

        // Navigate to the dashboard or home screen
        Get.snackbar("Success", response.body['message'] ?? "Logged In Successfully!");
        Get.offAllNamed(AppRoutes.customNavBar);
      } else {
        final errorMessage = response.body['message'] ?? "Failed to login.";
        Get.snackbar("Error", errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
