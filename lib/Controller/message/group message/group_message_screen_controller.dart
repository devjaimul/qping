import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';
import 'package:qping/services/socket_services.dart';

class GroupMessageController extends GetxController {
  var chatData = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  static const int limit = 10;

  @override
  void onInit() {
    fetchGroupList(isRefresh: true);

    // Listen for group conversation updates from socket
    SocketServices.socket.on('groupListUpdate', (data) {
      _handleIncomingGroupConversation(data);
    });

    super.onInit();
  }

  void _handleIncomingGroupConversation(dynamic updatedGroup) {
    if (updatedGroup == null) return;

    // Determine the new timestamp: use "lastActiveAt" if available,
    // otherwise fall back to "lastMessageCreatedAt"
    String? newTime = updatedGroup["lastActiveAt"] ?? updatedGroup["lastMessageCreatedAt"];

    // Find if the conversation exists by _id
    final index = chatData.indexWhere((c) => c["_id"] == updatedGroup["_id"]);
    if (index >= 0) {
      // Conversation exists: update only lastMessage and timestamp
      final existing = chatData[index];
      existing["lastMessage"] = updatedGroup["lastMessage"] ?? existing["lastMessage"];
      existing["lastActiveAt"] = newTime ?? existing["lastActiveAt"];
      chatData[index] = existing;
    } else {
      // New conversation: map the fields accordingly, using newTime for timestamp
      final newGroup = {
        "_id": updatedGroup["_id"],
        "name": updatedGroup["name"] ?? "",
        "avatar": updatedGroup["avatar"],
        "lastMessage": updatedGroup["lastMessage"] ?? "",
        "lastActiveAt": newTime,
      };
      chatData.add(newGroup);
    }

    _sortByLastActiveTime();
    chatData.refresh();
  }

  // Sort group conversations descending by lastActiveAt
  void _sortByLastActiveTime() {
    chatData.sort((a, b) {
      final dateA = DateTime.tryParse(a["lastActiveAt"] ?? "") ?? DateTime(1970);
      final dateB = DateTime.tryParse(b["lastActiveAt"] ?? "") ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });
  }

  Future<void> fetchGroupList({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      chatData.clear();
      totalPages.value = 1;
    }

    if (currentPage.value > totalPages.value) return;

    isLoading.value = true;

    final response = await ApiClient.getData(
      Urls.showGroupList(
        currentPage.value.toString(),
        limit.toString(),
        searchQuery.value,
        "yes",
      ),
    );

    if (response.statusCode == 200) {
      var responseBody = response.body;
      if (responseBody['ok'] == true) {
        totalPages.value = responseBody['pagination']['totalPages'];
        var groups = List<Map<String, dynamic>>.from(responseBody['data']);
        if (isRefresh) {
          chatData.assignAll(groups);
        } else {
          chatData.addAll(groups);
        }
        _sortByLastActiveTime();
        currentPage.value++;
      }
    }

    isLoading.value = false;
  }

  void searchGroups(String value) {
    searchQuery.value = value;
    fetchGroupList(isRefresh: true);
  }
}
