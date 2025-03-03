import 'package:get/get.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/services/socket_services.dart';
import 'package:qping/utils/urls.dart';

class MessageController extends GetxController {
  final chatData = <dynamic>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  static const int limit = 10;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Debounce search input so that the API call is triggered only after 500ms
    debounce(searchQuery, (_) {
      getAcceptChatList(isRefresh: true, type: 'accepted');
    }, time: const Duration(milliseconds: 500));

    // Listen to 'active-users' socket event (already in your code)
    SocketServices.socket.on('active-users', (data) {
      if (data != null) {
        bool isActive = data["isActive"] is bool ? data["isActive"] : false;
        String userId = data["id"];
        // Update only the conversation where receiverID matches the socket id
        for (var c in chatData) {
          if (c["receiverID"] == userId) {
            c["isActive"] = isActive;
          }
        }
        chatData.refresh();
      }
    });

    // ============================================
    //  Listen for updated conversation from socket
    //  Use your actual event name from the backend
    // ============================================
    SocketServices.socket.on('conversationListUpdate', (data) {
      _handleIncomingConversation(data);
    });
  }

  // Only update lastMessage fields; keep old name/profile
  void _handleIncomingConversation(dynamic updatedConversation) {
    if (updatedConversation == null) return;

    // 1. See if we already have this conversation
    final index = chatData.indexWhere((c) => c["_id"] == updatedConversation["_id"]);

    if (index >= 0) {
      // 2. Conversation exists: update ONLY lastMessage fields
      final existing = chatData[index];

      // Keep old participantName and profilePicture from existing
      // Update only the fields that should be "live"
      existing["lastMessage"] = updatedConversation["lastMessage"] ?? existing["lastMessage"];
      existing["lastMessageCreatedAt"] = updatedConversation["lastMessageCreatedAt"] ?? existing["lastMessageCreatedAt"];
      existing["updatedAt"] = updatedConversation["updatedAt"] ?? existing["updatedAt"];
      // If you want to track messageType, uncomment:
      // existing["messageType"] = updatedConversation["messageType"] ?? existing["messageType"];

      // Reassign the modified map back into the list
      chatData[index] = existing;
    } else {
      // 3. New conversation we haven't seen: insert it
      //    We do need to map the socket fields to your existing structure.
      //    The socket uses "name" => your code uses "participantName", etc.
      final newConv = {
        "_id": updatedConversation["_id"],
        "participantName": updatedConversation["name"] ?? "",      // or a fallback
        "profilePicture": updatedConversation["profilePicture"],  // might be null
        "lastMessage": updatedConversation["lastMessage"] ?? "",
        "lastMessageCreatedAt": updatedConversation["lastMessageCreatedAt"],
        "updatedAt": updatedConversation["updatedAt"],
        // if you need messageType:
        "messageType": updatedConversation["messageType"] ?? "text",
        // you might also need "receiverID" if it’s relevant
      };
      chatData.add(newConv);
    }

    // 4. Re-sort so newest conversation is on top
    _sortByLastMessageTime();

    // 5. Refresh to update the UI
    chatData.refresh();
  }

  // Sort by 'lastMessageCreatedAt' descending
  void _sortByLastMessageTime() {
    chatData.sort((a, b) {
      final dateA = DateTime.tryParse(a["lastMessageCreatedAt"] ?? "") ?? DateTime(1970);
      final dateB = DateTime.tryParse(b["lastMessageCreatedAt"] ?? "") ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });
  }

  Future<void> getAcceptChatList({
    bool isRefresh = false,
    required String type,
  }) async {
    if (isRefresh) {
      currentPage.value = 1;
      totalPages.value = 1;
      chatData.clear();
    }

    if (currentPage.value > totalPages.value) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiClient.getData(
        Urls.getChatList(
          currentPage.value.toString(),
          limit.toString(),
          type,
          searchQuery.value,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.body['data'];
        if (data is List) {
          chatData.addAll(data);
        }

        var pagination = response.body['pagination'];
        totalPages.value = pagination['totalPages'] ?? 1;

        if (pagination['nextPage'] != null) {
          currentPage.value = pagination['nextPage'];
        } else {
          currentPage.value = (pagination['currentPage'] as int) + 1;
        }

        // Sort after loading
        _sortByLastMessageTime();
      } else {
        errorMessage.value =
            response.body['message'] ?? "Failed to load chat list.";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void listenForIncomingMessages(String conversationId, senderName) {
    // If you have a specific event for a conversation, you could handle it here
    SocketServices.socket.on('conversation-$conversationId', (data) {
      // For example, handle direct conversation updates
    });
  }

  void markAsRead(int index) {
    chatData[index]['isUnread'] = false;
    chatData.refresh();
  }
}
