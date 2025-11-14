import 'package:get/get.dart';
import 'package:flash_clean/pages/home/home.controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
