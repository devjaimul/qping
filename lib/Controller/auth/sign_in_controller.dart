import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/routes/exports.dart';
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

        // await PrefsHelper.setString(
        //     AppConstants.isEmailVerified, isEmailVerified);
        // await PrefsHelper.setString(
        //     AppConstants.isProfilePicture, isProfilePicture);
        // await PrefsHelper.setString(AppConstants.isProfileID, isProfileID);

        // Navigate to the dashboard or home screen

        if (isProfileID == "null") {
          Get.snackbar("Unauthorized", response.body['message'] ?? "Profile Details Are Missing!!");
          Get.toNamed(AppRoutes.registrationScreen);
        }
        else if (isProfilePicture == "null") {
          Get.snackbar("Unauthorized", response.body['message'] ?? "Profile Picture Is Missing!!");
          Get.toNamed(AppRoutes.uploadPhotosScreen);
        }
        else {
          Get.snackbar("Success", response.body['message'] ?? "Logged In Successfully!");
          Get.offAllNamed(AppRoutes.customNavBar);
          await PrefsHelper.setString(AppConstants.isLogged, "true");
        }
      }
      else if (response.statusCode == 401) {
        final token = response.body['token'];
        await PrefsHelper.setString(AppConstants.bearerToken, token);
        Get.snackbar("Unauthorized", response.body['message'] ?? "If you did not receive a verification email, please check your spam folder or request a new verification Code.!");
        Get.to(() => OtpVerificationScreen(email: email,));
      }
      else {
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
