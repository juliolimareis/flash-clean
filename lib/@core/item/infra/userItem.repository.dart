import 'package:flash_clean/@core/item/entities/userItem.entity.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.repository.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

class UserItemRepository implements DatabaseRepositoryI<UserItemEntity> {
  late final DatabaseAdapterI<Map<String, dynamic>> _adapter;

  UserItemRepository({
    required DatabaseAdapterI<Map<String, dynamic>> adapter,
  }) {
    _adapter = adapter;
  }

  @override
  Future<List<UserItemEntity>> fetch(
    DatabaseAdapterFindOptions? options,
  ) async {
    final items = await _adapter.find(options);

    return items.map(UserItemEntity.fromMap).toList();
  }

  @override
  Future<UserItemEntity?> fetchById(String id) async {
    final item = await _adapter.findById(id, null);

    if (item != null) {
      return UserItemEntity.fromMap(item);
    }

    return null;
  }

  @override
  Future<List<UserItemEntity>> fetchByIds(List<String> ids) async {
    final items = await _adapter.findByIds(ids, null);

    return items.map(UserItemEntity.fromMap).toList();
  }

  @override
  Future<UserItemEntity> create(UserItemEntity userItem) async {
    final toInsert = userItem.toMap();
    toInsert.remove('id');

    final inserted = await _adapter.insert(toInsert);

    return UserItemEntity.fromMap(inserted);
  }

  @override
  Future<void> update(UserItemEntity userItem) async {
    if (userItem.id == null) {
      throw UserItemRepositoryException('Missing user ID');
    }

    await _adapter.update(userItem.id!, userItem.toMap());
  }

  @override
  Future<void> remove(String id) async {
    await _adapter.delete(id);
  }
}

class UserItemRepositoryException implements Exception {
  final String message;
  final int? code;

  UserItemRepositoryException(this.message, {this.code});

  @override
  String toString() {
    return "UserItemRepositoryException: $message (code: ${code ?? 'no code'})";
  }
}
