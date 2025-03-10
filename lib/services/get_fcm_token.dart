import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFCMToken() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      print("FCM Token: $fcmToken");
      return fcmToken;
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }
}
