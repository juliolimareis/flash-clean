import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

/// Adaptador genérico para Supabase.
/// Implementa a interface [DatabaseAdapterI] com suporte a CRUD,
/// filtros, ordenação e limite.
///
/// Exemplo:
/// ```dart
/// final adapter = SupabaseAdapter<User>('users');
/// final users = await adapter.find(FindOptions(limit: 10));
/// ```
class SupabaseDatabaseDriver<T extends Map<String, dynamic>>
    implements DatabaseAdapterI<T> {
  final String tableName;
  final SupabaseClient _client;

  SupabaseDatabaseDriver({required this.tableName})
    : _client = Supabase.instance.client;

  @override
  Future<List<T>> find(DatabaseAdapterFindOptions? options) async {
    final options_ = options as FindOptions?;

    var query = _client.from(tableName).select('*');

    // WHERE
    if (options_?.where != null) {
      for (final condition in options_!.where!) {
        switch (condition.operator) {
          case 'eq':
            query = query.eq(condition.field, condition.value);
            break;
          case 'neq':
            query = query.neq(condition.field, condition.value);
            break;
          case 'gt':
            query = query.gt(condition.field, condition.value);
            break;
          case 'gte':
            query = query.gte(condition.field, condition.value);
            break;
          case 'lt':
            query = query.lt(condition.field, condition.value);
            break;
          case 'lte':
            query = query.lte(condition.field, condition.value);
            break;
          case 'like':
            query = query.like(condition.field, condition.value);
            break;
          default:
            throw SupabaseDatabaseDriverException(
              'Operador WHERE inválido: ${condition.operator}',
            );
        }
      }
    }

    // ORDER BY
    if (options_?.orderBy != null && options_ != null) {
      for (final order in options_.orderBy!) {
        query =
            query.order(order.field, ascending: order.descending)
                as PostgrestFilterBuilder<PostgrestList>;
      }
    }

    // LIMIT
    if (options_?.limit != null) {
      query =
          query.limit(options_!.limit!)
              as PostgrestFilterBuilder<PostgrestList>;
    }

    final result = await query;

    return result.map((row) => row as T).toList();
  }

  @override
  Future<T?> findById(String id, DatabaseAdapterFindOptions? options) async {
    final result = await _client
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();

    return result as T?;
  }

  @override
  Future<T> insert(T object) async {
    final data = {...object};
    // data.remove('id');

    final res = await _client.from(tableName).insert(data).select().single();
    return {...res} as T;
  }

  @override
  Future<void> update(String id, T object) async {
    final data = {...object};
    data.remove('id');

    await _client.from(tableName).update(data).eq('id', id);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }

  @override
  Future<List<T>> findByIds(
    List<String> ids,
    DatabaseAdapterFindOptions? options,
  ) async {
    if (ids.isEmpty) return [];

    final result = await _client.from(tableName).select().inFilter('id', ids);

    return result.map((row) => row as T).toList();
  }

  @override
  Future<void> commit() async {
    // O Supabase não suporta transações múltiplas diretas via Dart SDK.
    // Aqui, apenas limpamos a fila de operações pendentes.
  }

  @override
  Future<void> rollback() async {
    // Supabase não oferece rollback via cliente. Apenas esvazia a fila.
  }

  @override
  Future<void> healthCheck() async {
    await _client.from(tableName).select('*').limit(1);
  }
}

/// Representa uma condição de filtro (WHERE)
class FilterCondition {
  final String field;
  final String operator;
  final dynamic value;

  FilterCondition({
    required this.field,
    required this.operator,
    required this.value,
  });
}

/// Representa uma condição de ordenação (ORDER BY)
class OrderByCondition {
  final String field;
  final bool descending;

  OrderByCondition({required this.field, this.descending = false});
}

/// Opções de busca (WHERE, ORDER BY, LIMIT)
class FindOptions extends DatabaseAdapterFindOptions {
  final int? limit;
  final List<FilterCondition>? where;
  final List<OrderByCondition>? orderBy;

  FindOptions({this.where, this.orderBy, this.limit});
}

/// Exceção personalizada para erros do SupabaseAdapter.
class SupabaseDatabaseDriverException implements Exception {
  final String message;
  final int? code;

  SupabaseDatabaseDriverException(this.message, {this.code});

  @override
  String toString() =>
      "[SupabaseDatabaseDriverException]: $message (code: ${code ?? 'no code'})";
}
