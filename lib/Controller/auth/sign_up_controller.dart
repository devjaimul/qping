import 'package:flutter/material.dart';
import 'package:qping/routes/exports.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class SignUpController extends GetxController {
  // Controllers for form fields
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String selectedCountryCode = '+1'; // Default country code
  final isLoading = false.obs; // Observable to track loading state

  Future<void> createAccount() async {
    isLoading.value = true;

    final fullPhoneNumber = "$selectedCountryCode${phoneController.text}";

    final body = {
      "name": userNameController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "phone": fullPhoneNumber,
    };

    try {
      final response = await ApiClient.postData(
        Urls.signUp,
        body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Success: Show success message and navigate to OTP verification
        Get.snackbar("Success", response.body['message'] ?? "Account created successfully!");
        Get.to(OtpVerificationScreen(email: emailController.text));
      } else {
        // Handle errors: Extract and format error messages
        final errorMessage = response.body['message'];
        String formattedMessage;

        if (errorMessage is List) {
          formattedMessage = errorMessage.join(", "); // Join list into a single string
        } else if (errorMessage is String) {
          formattedMessage = errorMessage; // Use the string directly
        } else {
          formattedMessage = "Something went wrong. Please try again.";
        }

        Get.snackbar("Error", formattedMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }




}
