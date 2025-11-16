import 'package:flash_clean/@core/user/entities/user.entity.dart';
import 'package:flash_clean/@core/user/infra/user.repository.dart';

class UserService {
  final UserRepository userRepository;

  UserService({required this.userRepository});

  Future<UserEntity?> getById(String id) async {
    return userRepository.fetchById(id);
  }

  Future<void> update(UserEntity user) async {
    return userRepository.update(user);
  }

  Future<UserEntity> add(UserEntity user) async {
    return userRepository.create(user);
  }
}
