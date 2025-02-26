import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/controller_bindings.dart';
import 'routes/app_routes.dart';
import 'services/socket_services.dart';
import 'themes/light_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SocketServices.init();
  runApp(const MyApp());
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
            // Initialize local notifications
            final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
            const InitializationSettings initializationSettings = InitializationSettings(
              android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              iOS: DarwinInitializationSettings(),
            );

            flutterLocalNotificationsPlugin.initialize(initializationSettings);

            return child!;
          },
        );
      },
    );
  }
}
