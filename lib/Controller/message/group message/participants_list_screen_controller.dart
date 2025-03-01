import 'package:qping/routes/exports.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/urls.dart';
import 'package:qping/views/Message/single%20message/message_chat_screen.dart';

class ParticipantsListScreenController extends GetxController {
  var participantsList = <dynamic>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var userRole = ''.obs;
  static const int limit = 15;


 // Fetch the current user's role in the group
  Future<void> getMyRole( String groupId) async {
    try {
      final response = await ApiClient.getData(
        Urls.getParticipantsRole(groupId),
      );

      if (response.statusCode == 200) {
        userRole.value = response.body['data']['role']; // Set role
      } else {
      //  Get.snackbar("Error", "Failed to load participant's role.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  // Function to get participants list from the API
  Future<void> getParticipantsList(String groupId) async {
    if (currentPage.value > totalPages.value) return; // No more pages to load

    isLoading.value = true;

    try {
      final response = await ApiClient.getData(
        Urls.participantsList(groupId, currentPage.value, limit),
      );

      if (response.statusCode == 200) {
        var data = response.body['data'];
        participantsList.addAll(data); // Add new participants to the list
        totalPages.value = response.body['pagination']['totalPages']; // Update total pages
        currentPage.value++; // Increment the current page
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to load participants.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Function to kick out the participant by sending their userId
  Future<void> kickOutUser(String userId,groupId) async {
    try {
      final response = await ApiClient.postData(
        Urls.removeFromParticipantsList(groupId,userId),
        {},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "User has been kicked out.");
        participantsList.removeWhere((participant) => participant['userId']['_id'] == userId);
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to kick out the user.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  // // Function to promote a participant to moderator
  Future<void> promoteToModerator(String userId,groupId) async {
    try {
      final response = await ApiClient.postData(
        Urls.promoteToModerator(groupId,userId),
        {},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "User has been promoted to moderator.");
        // Update participants list if necessary
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to promote to moderator.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  // create chat
  Future<void> createChat (String userId,message) async {
    try {
      final response = await ApiClient.postData(
        Urls.createChat(userId),
        {"message":message},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body['message']);
        Get.offAll(()=>const CustomNavBar());
      }
      else if (response.statusCode == 409) {
        Get.snackbar("Success", response.body['message']);
        Get.to(()=> MessageChatScreen(image:"${ApiConstants.imageBaseUrl}/${response.body['data']['profilePicture']}",
            name: response.body['data']['participantName'], conversationId: response.body['data']['_id']));
      }

      else {
        Get.snackbar("!!!!!", response.body['message'] ?? "Failed.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }
}
