// Controller Update
import 'dart:io';
import 'package:qping/routes/exports.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class CreateGroupController extends GetxController {
  var usersList = <dynamic>[].obs;
  var isLoading = false.obs;
  List<dynamic> allUsers = [];


  Future<void> getUsersList() async {
    isLoading.value = true;

      final response = await ApiClient.getData(Urls.addParticipantsList);
      if (response.statusCode == 200) {
        final data = response.body['data'];
        allUsers = data;
        usersList.assignAll(allUsers);
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to load users.");
      }
    isLoading.value = false;
  }

  Future<void> createGroup({
    required String groupName,
    required String groupType,
    required List<dynamic> selectedUserIds,
    required File? groupImage,
  }) async {
    isLoading.value = true;
    try {
      const uri = Urls.createGroup;

      // Prepare the form fields for the group creation
      Map<String, String> body = {
        'name': groupName,
        'type': groupType,
        'users': selectedUserIds.join(','),
      };
      List<MultipartBody> multipartBody = [];


      if (groupImage != null) {
        multipartBody.add(MultipartBody('avatar', groupImage));
      }


      final response = await ApiClient.postMultipartData(uri, body, multipartBody: multipartBody);

      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        Get.snackbar("Success", "Group created successfully.");
      } else {
        Get.snackbar("Failed", response.body['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUserToGroup({required List<dynamic> selectedUserIds,   required String groupId,}) async {

    isLoading.value = true;

    final body = {
      'userId': selectedUserIds,
    };

    try {
      final response = await ApiClient.postData(
        Urls.addUserToGroup(groupId),
        body,
      );

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar("Success", response.body['message'] ?? "User Added successfully!");


      } else {
        final errorMessage = response.body['message'] ?? "!!!!";
        Get.snackbar("!!", errorMessage);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Filter users locally based on name
  void filterUsers(String query) {
    if (query.isEmpty) {
      usersList.assignAll(allUsers);
    } else {
      usersList.assignAll(
        allUsers.where((user) => user['name'].toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}
