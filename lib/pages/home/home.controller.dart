import 'package:get/get.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/task/application/services/task.service.dart';
import 'package:flash_clean/@core/task/application/services/task.supabase.factory.service.dart';

class HomeController extends GetxController {
  RxInt energy = 5.obs;
  RxInt coins = 20.obs;
  int maxEnergy = 20;

  RxList<TaskEntity> tasks = <TaskEntity>[
    // TaskEntity(
    //   title: "Mesa da Sala",
    //   time: 5,
    //   desc: 'Limpar a mesa da sala',
    //   daysToExpire: 2,
    //   tagName: 'sala',
    //   imageUrlSide: "assets/images/sides/side_02.png",
    //   imageUrlBackground:
    //       "assets/images/cards_backgrounds/cards_backgrounds_02.jpeg",
    //   createdAt: "2025-10-01T00:00:00Z",
    //   lastRuleUpdated: "2025-11-01T00:00:00Z",
    // ),
    // TaskEntity(
    //   title: "Desinfetar Piso da cozinha",
    //   time: 15,
    //   desc: 'Desinfetar o piso da cozinha com produto X',
    //   daysToExpire: 10,
    //   tagName: 'cozinha',
    //   createdAt: "2024-10-01T00:00:00Z",
    //   lastRuleUpdated: "2025-11-04T00:00:00Z",
    // ),
    // TaskEntity(
    //   title: "Vidros das janelas",
    //   time: 25,
    //   desc: 'Limpar vidros das janelas da sala e quartos',
    //   daysToExpire: 10,
    //   tagName: 'geral',
    //   createdAt: "2024-10-01T00:00:00Z",
    //   lastRuleUpdated: "2025-11-02T00:00:00Z",
    // ),
    // TaskEntity(
    //   title: "Aspirar piso da sala",
    //   time: 10,
    //   desc: 'Aspirar todo o piso da sala',
    //   daysToExpire: 4,
    //   tagName: 'sala',
    // ),
  ].obs;

  final TaskService taskService = TaskServiceFactory.buildSupabase();

  @override
  void onReady() {
    super.onReady();
    onGetAllTasks();
  }

  Future<void> onGetAllTasks() async {
    tasks.value = await taskService.getAll(null);
  }
}
