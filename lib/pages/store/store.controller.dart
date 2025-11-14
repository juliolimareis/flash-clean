import 'package:get/get.dart';

class StoreController extends GetxController {
  var coins = 20.obs;
  var selectedItem = ''.obs;

  void buyItem(String name) {
    if (coins.value >= 10) {
      coins.value -= 10;
      selectedItem.value = name;
    }
  }
}
