import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/task/application/services/task.service.dart';
import 'package:flash_clean/@core/task/application/services/task.supabase.factory.service.dart';

class TaskFormController extends GetxController {
  final TaskService _taskService = TaskServiceFactory.buildSupabase();

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final timeController = TextEditingController();
  final tagNameController = TextEditingController();
  final daysToExpireController = TextEditingController();

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    timeController.dispose();
    tagNameController.dispose();
    daysToExpireController.dispose();
    super.onClose();
  }

  Future<void> saveTask() async {
    if (formKey.currentState!.validate()) {
      final newTask = TaskEntity(
        title: titleController.text,
        desc: descController.text,
        time: int.tryParse(timeController.text) ?? 0,
        tagName: tagNameController.text,
        daysToExpire: int.tryParse(daysToExpireController.text) ?? 0,
      );

      try {
        // await _taskService.(newTask);
        Get.back(result: true); // Go back and indicate success
      } catch (e) {
        Get.snackbar('Erro', 'Não foi possível salvar a tarefa.');
      }
    }
  }
}
