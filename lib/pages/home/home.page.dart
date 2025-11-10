import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flash_clean/pages/home/home.controller.dart';
import 'package:flash_clean/pages/home/components/task-card.dart';
import 'package:flash_clean/pages/home/components/home-appbar.component.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FlashCleanAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Energy Bar
              Obx(
                () => Text(
                  "${controller.energy.value}/${controller.maxEnergy}⚡",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Icon(Icons.flag, color: Colors.green),

              // Task List
              Expanded(
                child: Obx(() {
                  final sortedTasks = controller.tasks.toList()
                    ..sort(
                      (a, b) => b.expirationPercentage.compareTo(
                        a.expirationPercentage,
                      ),
                    );
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: sortedTasks.length,
                    itemBuilder: (context, index) {
                      final task = sortedTasks[index];
                      return Dismissible(
                        key: ObjectKey(task),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          controller.tasks.remove(task);
                        },
                        child: TaskCard(task: task),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 8),

              // Bottom Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.water_drop, color: Colors.blue),
                  Icon(Icons.diamond, color: Colors.cyan),
                  Icon(Icons.shield, color: Colors.amber),
                  Icon(Icons.star, color: Colors.orange),
                  Icon(Icons.sunny, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
