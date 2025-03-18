import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show AuthorizationStatus, FirebaseMessaging, NotificationSettings, RemoteMessage, RemoteNotification;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qping/routes/app_routes.dart' show AppRoutes;
import 'package:qping/services/internet/connectivity.dart';
import 'package:qping/services/internet/no_internet_wrapper.dart';
import 'package:qping/services/socket_services.dart';
import 'package:qping/themes/light_theme.dart' show light;
import 'Controller/controller_bindings.dart';
import 'firebase_options.dart';  // Add your firebase options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initializeNotifications();
  await setupFirebaseMessaging();
  SocketServices.init();

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

  Get.put(ConnectivityController());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // Optional: allow upside-down portrait
  ]).then((_) {
    runApp(MyApp());
  });;
}

// Initialize local notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions on iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }


  // Get FCM token (for sending targeted push notifications)
  String? token = await messaging.getToken();
  print('FCM Token: $token');

  // Listen for messages in the background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}


Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    notificationCategories: [], // Add this if you need custom actions later
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification tapped: ${response.payload}");
      Get.toNamed(AppRoutes.customNavBar); // Handle tap navigation
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received a message: ${message.notification?.title}");
    if (message.notification != null) {
      _showNotification(message.notification!);
    }
  });
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
            return Scaffold(body: NoInternetWrapper(child: child!));
          },
        );
      },
    );
  }
}
