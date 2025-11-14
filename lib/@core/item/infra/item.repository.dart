import 'package:flash_clean/@core/item/entities/Item.entity.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.repository.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

class ItemRepository implements DatabaseRepositoryI<ItemEntity> {
  late final DatabaseAdapterI<Map<String, dynamic>> _adapter;

  ItemRepository({required DatabaseAdapterI<Map<String, dynamic>> adapter}) {
    _adapter = adapter;
  }

  @override
  Future<List<ItemEntity>> fetch(DatabaseAdapterFindOptions? options) async {
    final items = await _adapter.find(null);

    return items.map(ItemEntity.fromMap).toList();
  }

  @override
  Future<ItemEntity?> fetchById(String id) async {
    final item = await _adapter.findById(id, null);

    if (item != null) {
      return ItemEntity.fromMap(item);
    }

    return null;
  }

  @override
  Future<List<ItemEntity>> fetchByIds(List<String> ids) async {
    final items = await _adapter.findByIds(ids, null);

    return items.map(ItemEntity.fromMap).toList();
  }

  @override
  Future<ItemEntity> create(ItemEntity item) async {
    final inserted = await _adapter.insert(item.toMap());

    return ItemEntity.fromMap(inserted);
  }

  @override
  Future<void> update(ItemEntity item) async {
    if (item.id == null) {
      throw ItemRepositoryException('Missing user ID');
    }

    await _adapter.update(item.id!, item.toMap());
  }

  @override
  Future<void> remove(String id) async {
    await _adapter.delete(id);
  }
}

class ItemRepositoryException implements Exception {
  final String message;
  final int? code;

  ItemRepositoryException(this.message, {this.code});

  @override
  String toString() {
    return "ItemRepositoryException: $message (code: ${code ?? 'no code'})";
  }
}
