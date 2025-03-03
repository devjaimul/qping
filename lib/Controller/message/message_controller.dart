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


    debounce(searchQuery, (_) {
      getAcceptChatList(isRefresh: true, type: 'accepted');
    }, time: const Duration(milliseconds: 500));


    SocketServices.socket.on('active-users', (data) {
      if (data != null) {
        bool isActive = data["isActive"] is bool ? data["isActive"] : false;
        String userId = data["id"];

        for (var c in chatData) {
          if (c["receiverID"] == userId) {
            c["isActive"] = isActive;
          }
        }
        chatData.refresh();
      }
    });


    SocketServices.socket.on('conversationListUpdate', (data) {
      _handleIncomingConversation(data);
    });
  }


  void _handleIncomingConversation(dynamic updatedConversation) {
    if (updatedConversation == null) return;


    final index = chatData.indexWhere((c) => c["_id"] == updatedConversation["_id"]);

    if (index >= 0) {

      final existing = chatData[index];


      existing["lastMessage"] = updatedConversation["lastMessage"] ?? existing["lastMessage"];
      existing["lastMessageCreatedAt"] = updatedConversation["lastMessageCreatedAt"] ?? existing["lastMessageCreatedAt"];
      existing["updatedAt"] = updatedConversation["updatedAt"] ?? existing["updatedAt"];

      chatData[index] = existing;
    } else {

      final newConv = {
        "_id": updatedConversation["_id"],
        "participantName": updatedConversation["name"] ?? "",
        "profilePicture": updatedConversation["profilePicture"],
        "lastMessage": updatedConversation["lastMessage"] ?? "",
        "lastMessageCreatedAt": updatedConversation["lastMessageCreatedAt"],
        "updatedAt": updatedConversation["updatedAt"],

        "messageType": updatedConversation["messageType"] ?? "text",

      };
      chatData.add(newConv);
    }


    _sortByLastMessageTime();


    chatData.refresh();
  }


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

    SocketServices.socket.on('conversation-$conversationId', (data) {

    });
  }

  void markAsRead(int index) {
    chatData[index]['isUnread'] = false;
    chatData.refresh();
  }
}
