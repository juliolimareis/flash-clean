import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/task/infra/task.repository.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

class TaskService {
  final TaskRepository taskRepository;

  TaskService({required this.taskRepository});

  Future<List<TaskEntity>> getAll(DatabaseAdapterFindOptions? options) async {
    return taskRepository.fetch(options);
  }

  Future<TaskEntity> add(TaskEntity task) async {
    return taskRepository.create(task);
  }
}
