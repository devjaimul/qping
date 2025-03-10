import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show FirebaseMessaging, RemoteMessage, RemoteNotification;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qping/routes/app_routes.dart' show AppRoutes;
import 'package:qping/services/socket_services.dart';
import 'package:qping/themes/light_theme.dart' show light;
import 'Controller/controller_bindings.dart';
import 'firebase_options.dart';  // Add your firebase options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initializeNotifications();  // Initialize local notifications
  SocketServices.init();  // If needed for socket setup

  // Register the Firebase messaging onMessage listener for receiving notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received a message: ${message.notification?.title}");
    if (message.notification != null) {
      _showNotification(message.notification!);
    }
  });

  // Handle the initial notification when the app is launched from a terminated state
  await _handleInitialMessage();

  // Register onMessageOpenedApp to handle notification taps
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification tapped: ${message.messageId}");
    Get.toNamed(AppRoutes.customNavBar);  // Navigate to a screen
  });

  runApp(const MyApp());
}

// Initialize local notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Show the notification when in the foreground
Future<void> _showNotification(RemoteNotification notification) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    notification.title,
    notification.body,
    platformChannelSpecifics,
  );
}

// Handle the initial notification when the app is launched from a terminated state
Future<void> _handleInitialMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("App launched from notification: ${initialMessage.messageId}");
    // Navigate to a specific screen or perform any action on app launch
    Get.toNamed(AppRoutes.customNavBar);  // Navigate to a screen
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          theme: light(),
          debugShowCheckedModeBanner: false,
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.splashScreen,
          initialBinding: ControllerBindings(),
          builder: (context, child) {
            return child!;
          },
        );
      },
    );
  }
}
