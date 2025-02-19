import 'package:get/get.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';
import 'package:flutter/services.dart';

class OtpVerificationController extends GetxController {
  final isLoading = false.obs;

  // Verify OTP
  Future<void> verifyOtp(String otpCode, bool? isFormForget) async {
    isLoading.value = true;

    final body = {"code": otpCode};

    try {
      final response = await ApiClient.postData(Urls.otpVerify, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", response.body['message'] ?? "OTP verified successfully!");

        String token = response.body['token'];
        String userId = response.body['data']['id'];
        await PrefsHelper.setString(AppConstants.bearerToken, token);
        await PrefsHelper.setString(AppConstants.userId, userId);

        if (isFormForget == true) {
          Get.toNamed(AppRoutes.resetPassScreen);
          await PrefsHelper.setString(AppConstants.isResetPass, "true");
        } else {
          Get.toNamed(AppRoutes.registrationScreen);
          await PrefsHelper.setString(AppConstants.isEmailVerified, "true");
        }

        // ✅ Close autofill context after successful OTP verification
        TextInput.finishAutofillContext();
      } else {
        final errorMessage = response.body['message'];
        final formattedMessage = errorMessage is List ? errorMessage.join(", ") : errorMessage ?? "Something went wrong.";
        Get.snackbar("!!!", formattedMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp(String email) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.postData(Urls.otpResend, {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", response.body['message'] ?? "OTP resent successfully!");
      } else {
        final errorMessage = response.body['message'];
        final formattedMessage = errorMessage is List ? errorMessage.join(", ") : errorMessage ?? "Something went wrong.";
        Get.snackbar("!!", formattedMessage);
      }
    } catch (e) {
      Get.snackbar("!!", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
