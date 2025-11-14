import 'package:flash_clean/@core/user/user.entity.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.repository.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

class UserRepository implements DatabaseRepositoryI<UserEntity> {
  late final DatabaseAdapterI<Map<String, dynamic>> _adapter;

  UserRepository({required DatabaseAdapterI<Map<String, dynamic>> adapter}) {
    _adapter = adapter;
  }

  @override
  Future<List<UserEntity>> fetch(DatabaseAdapterFindOptions? options) async {
    final items = await _adapter.find(null);

    return items.map(UserEntity.fromMap).toList();
  }

  @override
  Future<UserEntity?> fetchById(String id) async {
    final user = await _adapter.findById(id, null);

    if (user != null) {
      return UserEntity.fromMap(user);
    }

    return null;
  }

  @override
  Future<List<UserEntity>> fetchByIds(List<String> ids) async {
    final items = await _adapter.findByIds(ids, null);

    return items.map(UserEntity.fromMap).toList();
  }

  @override
  Future<UserEntity> create(UserEntity user) async {
    final inserted = await _adapter.insert(user.toMap());

    return UserEntity.fromMap(inserted);
  }

  @override
  Future<void> update(UserEntity user) async {
    if (user.id == null) {
      throw UserRepositoryException('Missing user ID');
    }

    await _adapter.update(user.id!, user.toMap());
  }

  @override
  Future<void> remove(String id) async {
    await _adapter.delete(id);
  }
}

class UserRepositoryException implements Exception {
  final String message;
  final int? code;

  UserRepositoryException(this.message, {this.code});

  @override
  String toString() {
    return "UserRepositoryException: $message (code: ${code ?? 'no code'})";
  }
}
