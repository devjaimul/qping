import 'package:flutter/material.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/exports.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';

class SignUpController extends GetxController {
  // Controllers for form fields
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String selectedPhoneNumber = ''; // Store the full formatted phone number
  final isLoading = false.obs;

  Future<void> createAccount() async {
    isLoading.value = true;

    final body = {
      "name": userNameController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "phone": selectedPhoneNumber, // Use formatted phone number
    };

    try {
      final response = await ApiClient.postData(
        Urls.signUp,
        body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Extract token and userID from response
        String token = response.body['token'];
        String userID = response.body['data']['_id'];

        // Save token and userID to shared preferences
        await PrefsHelper.setString(AppConstants.bearerToken, token);
        await PrefsHelper.setString(AppConstants.userId, userID);

        Get.snackbar("Success", response.body['message'] ?? "Account created successfully!");
        Get.to(()=>OtpVerificationScreen(email: emailController.text));

      } else {
        final errorMessage = response.body['message'];
        final formattedMessage = errorMessage is List
            ? errorMessage.join(", ")
            : errorMessage ?? "Something went wrong.";
        Get.snackbar("Error", formattedMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

}


