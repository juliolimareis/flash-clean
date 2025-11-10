import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.repository.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

class TaskRepository implements DatabaseRepositoryI<TaskEntity> {
  late final DatabaseAdapterI<Map<String, dynamic>> _adapter;

  TaskRepository({required DatabaseAdapterI<Map<String, dynamic>> adapter}) {
    _adapter = adapter;
  }

  @override
  Future<List<TaskEntity>> fetch(DatabaseAdapterFindOptions? options) async {
    final items = await _adapter.find(null);

    return items.map(TaskEntity.fromMap).toList();
  }

  @override
  Future<TaskEntity?> fetchById(String id) async {
    final item = await _adapter.findById(id, null);

    if (item != null) {
      return TaskEntity.fromMap(item);
    }

    return null;
  }

  @override
  Future<List<TaskEntity>> fetchByIds(List<String> ids) async {
    final items = await _adapter.findByIds(ids, null);

    return items.map(TaskEntity.fromMap).toList();
  }

  @override
  Future<TaskEntity> create(TaskEntity card) async {
    final inserted = await _adapter.insert(card.toMap());

    await _adapter.commit();
    return TaskEntity.fromMap(inserted);
  }

  @override
  Future<void> update(TaskEntity card) async {
    if (card.id == null) {
      throw CardRepositoryException('Missing user ID');
    }

    await _adapter.update(card.id!, card.toMap());
    await _adapter.commit();
  }

  @override
  Future<void> remove(String id) async {
    await _adapter.delete(id);
    await _adapter.commit();
  }
}

class CardRepositoryException implements Exception {
  final String message;
  final int? code;

  CardRepositoryException(this.message, {this.code});

  @override
  String toString() {
    return "CardRepositoryException: $message (code: ${code ?? 'no code'})";
  }
}
