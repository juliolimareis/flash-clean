import 'package:flash_clean/@core/common/entities/entity.dart';

abstract class DatabaseAdapterI<T extends Entity> {
  Future<T> insert(T object);
  Future<List<T>> find([dynamic options]);
  Future<List<T>> findByIds(List<String> ids, [dynamic options]);
  Future<T?> findById(String id, [dynamic options]);
  Future<void> update(String id, T object);
  Future<void> delete(String id);
  Future<void> commit();
  Future<void> rollback();
  Future<void> healthCheck();
}
