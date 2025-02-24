import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/services/socket_services.dart';
import 'package:qping/utils/urls.dart';

class GroupMessageChatScreenController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // Pagination properties
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  static const int limit = 10;
  RxBool isLoadingMessages = false.obs;

  String? myUserId;
  void setMyUserId(String id) {
    myUserId = id;
  }

  /// Fetch group messages using your GET API with pagination.
  Future<void> fetchGroupMessages(String groupId, {bool refresh = false, String type = 'group'}) async {
    if (refresh) {
      currentPage.value = 1;
      messages.clear();
    }

    if (currentPage.value > totalPages.value) return;

    isLoadingMessages.value = true;
    try {
      final response = await ApiClient.getData(
        Urls.chatMsgList(
          currentPage.value.toString(),
          limit.toString(),
          type,
          groupId,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.body['data'];
        var pagination = response.body['pagination'];

        List<Map<String, dynamic>> newMessages = (data as List).map((msg) {
          return {
            'type': msg['attachments'] != null &&
                (msg['attachments'] as List).isNotEmpty
                ? 'image'
                : 'text',
            'content': msg['attachments'] != null &&
                (msg['attachments'] as List).isNotEmpty
                ? msg['attachments'][0]['fileUrl']
                : msg['content'],
            'isSentByMe': myUserId != null ? (msg['sender'] == myUserId) : false,
            'time': DateFormat('h.mm a')
                .format(DateTime.parse(msg['createdAt']).toLocal()),
            'senderName': msg['senderName'],
            'profilePicture': msg['profilePicture'],
          };
        }).toList();

        messages.addAll(newMessages);
        totalPages.value = pagination['totalPages'] ?? 1;
        currentPage.value = (pagination['currentPage'] as int) + 1;
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed to retrieve messages");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  /// Initialize the socket connection and join the group.
  void initSocketAndJoinGroup(String groupId) {
    SocketServices.emit('join', {
      'groupId': groupId,
    });
    listenForIncomingMessages(groupId);
  }

  /// Listen for incoming messages via socket.
  void listenForIncomingMessages(String groupId) {
    SocketServices.socket.on('conversation-$groupId', (data) {
      if (data != null) {
        final bool isSentByMe = data['sender'] == myUserId;
        final String messageType = data['type'] ?? 'text';
       final String content = data['content'] ?? '';
       final String senderName = data['senderName'] ?? '';
       final String profilePicture = data['profilePicture'] ?? '';

        messages.insert(0, {
          'type': messageType == 'image' ? 'image' : 'text',
          'content': content,
          'isSentByMe': isSentByMe,
          'senderName': senderName,
          'profilePicture': profilePicture,
          'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
        });
      }
    });
  }

  /// Send a message over the socket.
  void sendMessageToSocket(String groupId, String content, {String type = 'group'}) {
    final body = {
      'groupId': groupId,
      'content': content,
      'messageOn': type,
    };
    SocketServices.emit('send-message', body);
  }

  /// Poll functions
  void addPoll() {
    messages.add({
      'type': 'poll',
      'isSentByMe': true,
      'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
      'poll': {
        'question': 'Henry created an attendance poll',
        'options': [
          {'text': 'Present', 'selected': false},
          {'text': 'Not Present / Unavailable', 'selected': false},
        ],
      }
    });
  }

  void updatePoll(int index, int optionIndex, bool value) {
    var poll = messages[index]['poll'];
    poll['options'][optionIndex]['selected'] = value;
    messages[index] = {...messages[index], 'poll': poll};
  }
}
