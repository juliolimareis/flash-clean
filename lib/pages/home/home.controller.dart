import 'package:flash_clean/@core/item/entities/Item.entity.dart';
import 'package:flash_clean/@core/user/entities/userInventoryItem.entity.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flash_clean/@core/user/entities/user.entity.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/item/application/services/item.service.dart';
import 'package:flash_clean/@core/task/application/services/task.service.dart';
import 'package:flash_clean/@core/user/application/services/user.service.dart';
import 'package:flash_clean/@core/item/application/services/item.service.factory.dart';
import 'package:flash_clean/@core/user/application/services/user.service.factory.dart';
import 'package:flash_clean/@core/task/application/services/task.supabase.factory.service.dart';

final MAX_ENERGY = 20;

class HomeController extends GetxController {
  final RxInt maxEnergy = 0.obs;
  final RxInt energy = 0.obs;
  final RxInt cash = 0.obs;
  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final RxMap<String, dynamic> undo = RxMap<String, dynamic>();
  final RxList<TaskEntity> tasks = <TaskEntity>[].obs;
  final RxBool isLoading = true.obs;
  final userItems = <UserInventoryItemEntity>[].obs;

  final supabaseUser = Supabase.instance.client.auth.currentUser;

  final UserService userService = UserServiceFactory.buildSupabase();
  final TaskService taskService = TaskServiceFactory.buildSupabase();
  final ItemService itemService = ItemServiceFactory.buildSupabase();

  @override
  void onReady() {
    super.onReady();
    getUser().then((_) {
      handleRecoveryEnergy();
      getUserItems();
    });
    maxEnergy.value = MAX_ENERGY;
  }

  Future<void> getUserItems() async {
    userItems.value = await itemService.getUserItemsInventory(supabaseUser!.id);
    onGetAllTasksWithLoader();
  }

  Future<void> getUser() async {
    final userData = await userService.getById(supabaseUser!.id);

    if (userData == null) {
      user.value = await userService.add(
        UserEntity(id: supabaseUser!.id, cash: 0, ticket: 0, energy: 0),
      );
    } else {
      user.value = userData;
    }

    energy.value = user.value!.energy;
    cash.value = user.value!.cash;
  }

  String cashLabel() {
    return "${cash}";
  }

  bool get isNewDay {
    final lastUpdated = user.value!.lastUpdatedEnergy;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    if (lastUpdated.isBefore(midnight)) {
      return true;
    } else {
      return false;
    }
  }

  void handleRecoveryEnergy() async {
    if (isNewDay) {
      if (energy.value < maxEnergy.value) {
        energy.value = maxEnergy.value - energy.value;
      } else {
        energy.value = 0;
      }

      user.value!.setEnergy(energy.value);
      user.value!.lastUpdatedEnergy = DateTime.now();

      await updateUser();
    }
  }

  Future<void> onUndoTask() async {
    UserEntity userUndo = undo["user"];
    TaskEntity taskUndo = undo["task"];

    this.user.value = userUndo;
    this.energy.value = userUndo.energy;
    this.cash.value = userUndo.cash;

    await updateTask(taskUndo);
    await updateUser();
    undo.clear();
  }

  Future<void> chooseTask(TaskEntity task) async {
    undo["user"] = UserEntity.fromMap(user.value!.toMap());
    undo["task"] = TaskEntity.fromMap(task.toMap());

    task.touchLastRuleUpdated();
    await updateTask(task);

    if (task.time <= maxEnergy.value && energy.value < maxEnergy.value) {
      this.energy.value += task.time;

      if (energy.value > maxEnergy.value) {
        energy.value = maxEnergy.value;
      }

      this.cash.value += task.time;
      user.value!.setCash(this.cash.value);
      user.value!.setEnergy(this.energy.value);

      await updateUser();
    }

    showUndoSnackbar(task);
  }

  void showUndoSnackbar(TaskEntity task) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      'Undo',
      task.title,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.blueAccent,
      duration: Duration(seconds: 10),
      onTap: (snack) {
        Get.closeCurrentSnackbar();
        onUndoTask();
      },
    );
  }

  Future<void> updateUser() async {
    await userService.update(user.value!);
  }

  Future<void> updateTask(TaskEntity task) async {
    await taskService.update(task);
    onGetAllTasks();
  }

  Future<void> onGetAllTasksWithLoader() async {
    isLoading.value = true;
    await onGetAllTasks();
    isLoading.value = false;
  }

  Future<void> onGetAllTasks() async {
    final currentTasks = await taskService.getAll(null);

    for (TaskEntity task in currentTasks) {
      final activeSkin = getActiveSkin();
      final activeSide = getActiveSide();

      if (activeSkin != null) {
        task.imageUrlBackground = activeSkin.item.imageUrl;
      }

      if (activeSide != null) {
        task.imageUrlSide = activeSide.item.imageUrl;
      }
    }

    tasks.value = currentTasks
      ..sort(
        (a, b) => b.expirationPercentage.compareTo(a.expirationPercentage),
      );
  }

  Future<void> goToStore() async {
    Get.toNamed('/store');
  }

  UserInventoryItemEntity? getActiveSkin() {
    final userItem = userItems.firstWhereOrNull(
      (userItem) => userItem.item.type == ItemType.SKIN && userItem.isActive,
    );

    if (userItem != null) {
      if (userItem.isExpired) {
        itemService.removeUserItem(userItem.id as String);
        return null;
      }
      return userItem;
    }

    return null;
  }

  UserInventoryItemEntity? getActiveSide() {
    final userItem = userItems.firstWhereOrNull(
      (userItem) => userItem.item.type == ItemType.SIDE && userItem.isActive,
    );

    if (userItem != null) {
      if (userItem.isExpired) {
        itemService.removeUserItem(userItem.id as String);
        return null;
      }
      return userItem;
    }

    return null;
  }

  UserInventoryItemEntity? getActiveArtefact() {
    return userItems.firstWhereOrNull(
      (userItem) =>
          userItem.item.type == ItemType.ARTEFACT && userItem.isActive,
    );
  }
}
