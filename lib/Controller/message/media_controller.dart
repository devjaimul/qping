import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/urls.dart';

class MediaController extends GetxController {
  var mediaImages = <String>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;

  // Dummy conversationId and type; replace with real values as needed.

  final String type = "image";
  final int limit = 10;

  Future<void> fetchMediaImages({bool refresh = false,required String conversationId,type}) async {
    if (refresh) {
      currentPage.value = 1;
      mediaImages.clear();
    }
    // Prevent multiple calls or stop if no more pages.
    if (isLoading.value || (currentPage.value > totalPages.value && totalPages.value != 0)) return;

    isLoading.value = true;
    try {
      final response = await ApiClient.getData(
        Urls.getAllMedia(
          currentPage.value.toString(),
          limit.toString(),
          conversationId,
          type,
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.body['data'];
        List<String> newImages = data.map((img) {
          return "${ApiConstants.imageBaseUrl}/${img['fileUrl']}";
        }).toList();
        mediaImages.addAll(newImages);
        totalPages.value = response.body['pagination']['totalPages'] ?? 1;
        // Increment page using the currentPage value from the API.
        currentPage.value = (response.body['pagination']['currentPage'] as int) + 1;
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to fetch media images");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
