import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

/// Contrato genérico para a camada de Repositório.
/// Define as operações básicas de persistência de dados.
/// [E] é o tipo da entidade gerenciada.
abstract class DatabaseRepositoryI<E> {
  Future<List<E>> fetch(DatabaseAdapterFindOptions? options);
  Future<E?> fetchById(String id);
  Future<List<E>> fetchByIds(List<String> ids);
  Future<E> create(E entity);
  Future<void> update(E entity);
  Future<void> remove(String id);
}
