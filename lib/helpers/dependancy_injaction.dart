
import 'package:get/get.dart';


class DependencyInjection implements Bindings {

  DependencyInjection();

  @override
  void dependencies() {
    // Get.lazyPut(() => AuthController(), fenix: true);
  }
}