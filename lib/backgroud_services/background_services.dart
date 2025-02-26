import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeBackgroundService() async {
  await flutterLocalNotificationsPlugin.initialize(InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  ));

  final service = FlutterBackgroundService();

  service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'default_notification_channel',
      initialNotificationTitle: 'Running in the Background',
      initialNotificationContent: 'Real-time messaging is active.',
      foregroundServiceNotificationId: 100,
    ),
    iosConfiguration: IosConfiguration(onBackground: iosBackground),
  );

  service.startService();
}

void onStart(ServiceInstance service) {
  print('Background service started...');
}

Future<bool> iosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}
