import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/exports.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';

class EmailVerificationController extends GetxController {
  final isLoading = false.obs;

  Future<void> sendOtp(String email) async {

    isLoading.value = true;

    final body = {
      "email": email,
    };

    try {
      final response = await ApiClient.postData(
        Urls.emailVerify,
        body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message'] ?? "OTP sent successfully!");
        final token = response.body['token'];
        await PrefsHelper.setString(AppConstants.bearerToken, token);

        Get.to(()=>OtpVerificationScreen(email: email,isFormForget:true));
      } else {
        final errorMessage = response.body['message'] ?? "Failed to send OTP.";
        Get.snackbar("Error", errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
