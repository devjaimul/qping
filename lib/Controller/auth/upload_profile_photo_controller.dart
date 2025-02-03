import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';

class UploadProfilePhotoController extends GetxController {
  final isLoading = false.obs;


  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
  Future<void> uploadProfilePicture({File? imageFile, String? avatarPath}) async {
    isLoading.value = true;

    try {
      // Prepare the multipart body
      final multipartBody = <MultipartBody>[];

      // If an image file is selected, add it to the multipart body
      if (imageFile != null) {
        multipartBody.add(MultipartBody('file', imageFile));
      }

      // If an avatar is selected, load it as a file and add it to the multipart body
      if (avatarPath != null) {
        final file = await _loadAssetAsFile(avatarPath);
        multipartBody.add(MultipartBody('file', file));
      }

      // Call the API
      final response = await ApiClient.postMultipartData(
        Urls.profilePicture,
        {}, // No additional fields needed
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message'] ?? "Profile Picture Uploaded Successfully!");
        await PrefsHelper.setString(AppConstants.isProfilePicture,"true");
        Get.offAllNamed(AppRoutes.customNavBar); // Navigate to home or desired route
      } else {
        final errorMessage = response.body['message'] ?? "Failed to upload profile picture.";
        Get.snackbar("Error", errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper: Load an asset image as a File
  Future<File> _loadAssetAsFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }
}
