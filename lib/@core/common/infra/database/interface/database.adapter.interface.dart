class DatabaseAdapterFindOptions {}

abstract class DatabaseAdapterI<T extends Map<String, dynamic>> {
  Future<T> insert(T object);
  Future<List<T>> find(DatabaseAdapterFindOptions? options);
  Future<List<T>> findByIds(
    List<String> ids,
    DatabaseAdapterFindOptions? options,
  );
  Future<T?> findById(String id, DatabaseAdapterFindOptions? options);
  Future<void> update(String id, T object);
  Future<void> delete(String id);
  Future<void> commit();
  Future<void> rollback();
  Future<void> healthCheck();
}
