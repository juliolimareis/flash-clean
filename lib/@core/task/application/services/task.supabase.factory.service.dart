import 'package:flash_clean/@core/task/infra/task.repository.dart';
import 'package:flash_clean/@core/task/application/services/task.service.dart';
import 'package:flash_clean/@core/common/infra/drvers/supabase.database.driver.dart';

class TaskServiceFactory {
  static buildSupabase() {
    final supabaseDatabaseDriver = SupabaseDatabaseDriver(tableName: 'tasks');
    final taskRepository = TaskRepository(adapter: supabaseDatabaseDriver);

    return TaskService(taskRepository: taskRepository);
  }
}
