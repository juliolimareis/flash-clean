import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flash_clean/pages/home/home.controller.dart';
import 'package:flash_clean/@core/item/entities/Item.entity.dart';
import 'package:flash_clean/@core/item/application/services/item.service.dart';
import 'package:flash_clean/@core/item/application/services/item.service.factory.dart';

class StoreController extends GetxController {
  final coins = 20.obs;
  final selectedItem = Rxn<ItemEntity>(null);
  final items = <ItemEntity>[].obs;
  final ItemService itemService = ItemServiceFactory.buildSupabase();

  final supabaseUser = Supabase.instance.client.auth.currentUser;
  final homeController = Get.find<HomeController>();

  @override
  void onReady() {
    super.onReady();
    getAllStoreItems();
  }

  Future<void> getAllStoreItems() async {
    items.value = await itemService.getStoreItems();
    items.sort((a, b) {
      final aOwned = userHaveThisItem(a);
      final bOwned = userHaveThisItem(b);

      if (aOwned && !bOwned) {
        return 1;
      } else if (!aOwned && bOwned) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  bool userHaveThisItem(ItemEntity item) {
    final findItem = homeController.userItems.firstWhereOrNull(
      (userItem) => userItem.item.id == item.id,
    );

    return findItem != null;
  }

  void selectItem(ItemEntity item) {
    selectedItem.value = item;
  }

  void buyItem() {
    print("Buying item ${selectedItem.value!.id}");
  }

  bool hasCash(ItemEntity item) {
    if (homeController.cash.value >= item.price) {
      return true;
    }

    // return false;
    return true;
  }
}
