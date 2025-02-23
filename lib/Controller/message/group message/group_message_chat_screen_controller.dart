import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupMessageChatScreenController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  void addTextMessage(String content) {
    messages.add({
      'type': 'text',
      'content': content,
      'isSentByMe': true,
      'time': DateFormat('h.mm a').format(DateTime.now().toLocal()),
    });
  }

  void addImageMessage(String path) {
    messages.add({
      'type': 'image',
      'content': path,
      'isSentByMe': true,
      'time':  DateFormat('h.mm a').format(DateTime.now().toLocal()),
    });
  }

  void addPoll() {
    messages.add({
      'type': 'poll',
      'isSentByMe': true,
      'time':  DateFormat('h.mm a').format(DateTime.now().toLocal()),
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
    messages[index] = {...messages[index], 'poll': poll}; // Update the observable
  }
}