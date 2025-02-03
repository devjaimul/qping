import 'package:get/get.dart';

class MessageController extends GetxController {
  final chatData = [
    {"name": "Jane Cooper", "time": "4:30 PM", "isUnread": true}.obs,
    {"name": "Wade Warren", "time": "1:30 PM", "isUnread": true}.obs,
    {"name": "Jenny Wilson", "time": "4:30 PM", "isUnread": false}.obs,
    {"name": "Robert Fox", "time": "4:30 PM", "isUnread": false}.obs,
    {"name": "Guy Hawkins", "time": "4:30 PM", "isUnread": false}.obs,
    {"name": "Jacob Jones", "time": "4:30 PM", "isUnread": false}.obs,
    {"name": "Cody Fisher", "time": "4:30 PM", "isUnread": false}.obs,
  ].obs;

  void markAsRead(int index) {
    chatData[index]['isUnread'] = false;
    chatData.refresh();
  }
}
