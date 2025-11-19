import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flash_clean/pages/home/home.controller.dart';
import 'package:flash_clean/@core/item/entities/Item.entity.dart';
import 'package:flash_clean/@core/item/entities/userItem.entity.dart';
import 'package:flash_clean/@core/item/application/services/item.service.dart';
import 'package:flash_clean/@core/item/application/services/item.service.factory.dart';

class StoreController extends GetxController {
  final coins = 20.obs;
  final items = <ItemEntity>[].obs;
  final skinItems = <ItemEntity>[].obs;
  final sideItems = <ItemEntity>[].obs;

  final selectedItem = Rxn<ItemEntity>(null);
  final ItemService itemService = ItemServiceFactory.buildSupabase();

  final supabaseUser = Supabase.instance.client.auth.currentUser;
  final homeController = Get.find<HomeController>();

  @override
  void onReady() {
    super.onReady();
    getAllStoreItems();
  }

  Future<void> getAllStoreItems() async {
    final allItems = await itemService.getStoreItems();

    allItems.sort((a, b) {
      final aOwned = userHaveThisItem(b);
      final bOwned = userHaveThisItem(a);

      if (aOwned && !bOwned) {
        return 1;
      } else if (!aOwned && bOwned) {
        return -1;
      } else {
        return 0;
      }
    });

    items.value = allItems;
    skinItems.value = allItems.where((i) => i.type == ItemType.SKIN).toList();
    sideItems.value = allItems.where((i) => i.type == ItemType.SIDE).toList();
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

  Future<void> buyItem() async {
    if (selectedItem.value != null && selectedItem.value!.id != null) {
      homeController.cash.value -= selectedItem.value!.price;
      homeController.user.value!.cash = homeController.cash.value;
      await homeController.updateUser();

      await itemService.addUserItem(
        UserItemEntity(
          userId: supabaseUser!.id,
          itemId: selectedItem.value!.id as String,
          expirationDays: selectedItem.value!.expirationDays,
        ),
      );

      await homeController.getUserItems();
      homeController.onGetAllTasks();
      getAllStoreItems();

      Get.snackbar(
        'Success!',
        'You have bought ${selectedItem.value!.title}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      selectedItem.value = null;
    }
  }

  bool hasCash(ItemEntity item) {
    if (homeController.cash.value >= item.price) {
      return true;
    }

    return false;
  }

  bool isItemActive(ItemEntity item) {
    final findItem = homeController.userItems.firstWhereOrNull(
      (userItem) => userItem.item.id == item.id,
    );

    if (findItem != null) {
      return findItem.isActive;
    }

    return false;
  }

  void activeItem(ItemEntity item, bool isActive) async {
    final itemFound = homeController.userItems.firstWhereOrNull(
      (userItem) => userItem.item.id == item.id,
    );

    if (itemFound != null) {
      if (isActive && itemFound.item.type == ItemType.SKIN) {
        final enabledSkin = homeController.getActiveSkin();

        if (enabledSkin != null) {
          enabledSkin.isActive = false;
          await itemService.updateUserItem(enabledSkin);
        }
      }

      if (isActive && itemFound.item.type == ItemType.SIDE) {
        final enabledSide = homeController.getActiveSide();

        if (enabledSide != null) {
          enabledSide.isActive = false;
          await itemService.updateUserItem(enabledSide);
        }
      }

      itemFound.isActive = isActive;
      await itemService.updateUserItem(itemFound);
    }

    await homeController.getUserItems();
    await getAllStoreItems();
  }
}
