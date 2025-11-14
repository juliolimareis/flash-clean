import 'package:flash_clean/@core/user/infra/user.repository.dart';
import 'package:flash_clean/@core/user/application/services/user.service.dart';
import 'package:flash_clean/@core/common/infra/drvers/supabase.database.driver.dart';

class UserServiceFactory {
  static buildSupabase() {
    final supabaseDatabaseDriver = SupabaseDatabaseDriver(tableName: 'user');
    final userRepository = UserRepository(adapter: supabaseDatabaseDriver);

    return UserService(userRepository: userRepository);
  }
}
