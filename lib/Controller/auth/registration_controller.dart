import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';

class RegistrationController extends GetxController {
  final isLoading = false.obs;

  Future<void> createProfile({
    required String fullName,
    required String address,
    required String dob,
    required String gender,
  }) async {
    isLoading.value = true;

    final body = {
      "fullName": fullName,
      "address": address,
      "dOB": dob,
      "gender": gender,
    };

    try {
      final response = await ApiClient.postData(
        Urls.registration,
        body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message'] ?? "Profile created successfully!");
        // String token = response.body['token'];
        // // Save token and userID to shared preferences
        // await PrefsHelper.setString(AppConstants.bearerToken, token);

        Get.toNamed(AppRoutes.uploadPhotosScreen);

        await PrefsHelper.setString(AppConstants.isProfileID,"true");

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
