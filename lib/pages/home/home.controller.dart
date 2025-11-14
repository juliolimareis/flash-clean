import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flash_clean/@core/user/user.entity.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/task/application/services/task.service.dart';
import 'package:flash_clean/@core/user/application/services/user.service.dart';
import 'package:flash_clean/@core/user/application/services/user.service.factory.dart';
import 'package:flash_clean/@core/task/application/services/task.supabase.factory.service.dart';

final MAX_ENERGY = 20;

class HomeController extends GetxController {
  RxInt maxEnergy = 0.obs;
  RxInt energy = 0.obs;
  RxInt cash = 0.obs;
  Rxn<UserEntity> user = Rxn<UserEntity>();

  final supabaseUser = Supabase.instance.client.auth.currentUser;

  RxList<TaskEntity> tasks = <TaskEntity>[].obs;

  final UserService userService = UserServiceFactory.buildSupabase();
  final TaskService taskService = TaskServiceFactory.buildSupabase();

  @override
  void onReady() {
    super.onReady();
    onGetAllTasks();
    getUser();
    maxEnergy.value = MAX_ENERGY;
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
  }

  String cashLabel() {
    return "${cash}";
  }

  //crie uma função para verificar se ultima vez que user.lastUpdatedEnergy foi atualizado a 24h atrás
  //  bool wasEnergyUpdatedInLast24Hours() {
  void recoveryEnergy() async {
    final lastUpdated = user.value!.lastUpdatedEnergy;

    if (DateTime.now().difference(lastUpdated).inHours < 24) {
      user.value!.setEnergy(0);
      await updateUser();
    }
  }

  Future<void> chooseTask(TaskEntity task) async {
    task.touchLastRuleUpdated();
    await taskService.update(task);
    await onGetAllTasks();

    if (task.time < maxEnergy.value && energy.value < maxEnergy.value) {
      await sumEnergy(task.time);

      if (energy.value > maxEnergy.value) {
        energy.value = maxEnergy.value;
      }

      await updateUser();
    }
  }

  Future<void> sumEnergy(int energy) async {
    this.cash.value += energy;
    this.energy.value += energy;
    user.value!.setCash(this.cash.value);
    user.value!.setEnergy(this.energy.value);
  }

  Future<void> updateUser() async {
    await userService.update(user.value!);
  }

  Future<void> onGetAllTasks() async {
    tasks.value = await taskService.getAll(null);
  }

  Future<void> goToStore() async {
    Get.toNamed('/store');
  }
}
