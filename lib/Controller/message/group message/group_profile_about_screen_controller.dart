import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/urls.dart';


class GroupProfileAboutController extends GetxController {
  var notificationsEnabled = true.obs;

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  // method to leave the group
  Future<void> leaveGroup(String groupId) async {
      final response = await ApiClient.postData(
        Urls.leaveGroup(groupId),{}
      );
      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message']);

        Get.offAllNamed(AppRoutes.customNavBar);
      } else {
        Get.snackbar("!!!", response.body['message'] ?? "Failed to leave the group.");
      }
  }
}
