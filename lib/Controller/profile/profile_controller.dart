import 'dart:io';
import 'package:get/get.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class ProfileController extends GetxController {
  var profile = {}.obs;
  final isLoading = false.obs;

  // Fetch profile data from the API
  Future<void> fetchProfile() async {
    if (isLoading.value) return;

    isLoading.value = true;

    final response = await ApiClient.getData(Urls.getProfile);

    if (response.statusCode == 200) {
      profile.value = response.body['data'];
    } else {
      print('Error fetching profile: ${response.statusText}');
    }

    isLoading.value = false;
  }

  // Update profile (including the profile picture)
  Future<void> updateProfile({
    String? name,
    File? imageFile,
  }) async {
    isLoading.value = true;

    try {
      final multipartBody = <MultipartBody>[];

      // If there's a new image, include it in the request
      if (imageFile != null) {
        multipartBody.add(MultipartBody('file', imageFile));
      }

      // Prepare the data for the update
      final Map<String, String> body = {
        'name': name ?? profile['fullName'],

      };

      // Make the API call to update the profile
      final response = await ApiClient.patchMultipartData(
        Urls.updateProfile,
        body,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message'] ?? "Profile Updated Successfully!");
        fetchProfile();
        Get.offAllNamed(AppRoutes.customNavBar);
      } else {
        final errorMessage = response.body['message'] ?? "Failed to update profile.";
        Get.snackbar("Error", errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
