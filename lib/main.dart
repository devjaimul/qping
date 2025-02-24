import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/controller_bindings.dart';
import 'routes/app_routes.dart';
import 'services/socket_services.dart';
import 'themes/light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SocketServices.init();
  // runApp(DevicePreview(
  //   enabled: false, // Set to false to disable DevicePreview in production.
  //   builder: (_) => const MyApp(),
  // ));

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
          // builder: DevicePreview.appBuilder, // Add this line to wrap the app in DevicePreview.
          // locale: DevicePreview.locale(context), // Adds support for locale preview.
        );
      },
    );
  }
}
