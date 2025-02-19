// Controller Update
import 'dart:io';
import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:qping/views/Message/group%20message/group_message_chat_screen.dart';
import 'package:qping/views/Message/single%20message/message_chat_screen.dart';

class CreateGroupController extends GetxController {
  var usersList = <dynamic>[].obs;
  var isLoading = false.obs;
  List<dynamic> allUsers = [];

  // Function to fetch users list
  Future<void> getUsersList() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.getData(Urls.addParticipantsList);
      if (response.statusCode == 200) {
        final data = response.body['data'];
        allUsers = data;
        usersList.assignAll(allUsers);
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to load users.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Function to create a group
  Future<void> createGroup({
    required String groupName,
    required String groupType,
    required List<dynamic> selectedUserIds,
    required File? groupImage,
  }) async {
    isLoading.value = true;
    try {
      final uri = Urls.createGroup;

      // Prepare the form fields for the group creation
      Map<String, String> body = {
        'name': groupName,
        'type': groupType,
        'users': selectedUserIds.join(','),
      };
      print("==============================$body");
      List<MultipartBody> multipartBody = [];

      // If there's an image, add it to the multipart request
      if (groupImage != null) {
        multipartBody.add(MultipartBody('avatar', groupImage));
      }

      // Call API client to create the group via multipart POST request
      final response = await ApiClient.postMultipartData(uri, body, multipartBody: multipartBody);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Group created successfully.");
        Get.to(() => GroupMessageChatScreen());  // Navigate to the chat screen
      } else {
        Get.snackbar("Error", "Failed to create group.");
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
