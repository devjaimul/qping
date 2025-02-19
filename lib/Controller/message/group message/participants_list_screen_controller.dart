import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';

class ParticipantsListScreenController extends GetxController {
  var participantsList = <dynamic>[].obs;
  var isLoading = false.obs;

  // Function to get participants list from the API
  Future<void> getParticipantsList(String groupId) async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(
        Urls.participantsList(groupId), // Updated to GET request
      );

      if (response.statusCode == 200) {
        participantsList.value = response.body['data']; // Assign participants list
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
  Future<void> kickOutUser(String userId) async {
    try {
      final response = await ApiClient.postData(
        Urls.removeFromParticipantsList(userId), // Send the userId to remove the participant
        {},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "User has been kicked out.");
        // Optionally, remove the user from the participants list immediately
        participantsList.removeWhere((participant) => participant['userId']['_id'] == userId);
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to kick out the user.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }
}
