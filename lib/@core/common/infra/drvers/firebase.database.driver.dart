import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_clean/@core/common/entities/entity.dart';

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
class FindOptions {
  final List<FilterCondition>? where;
  final List<OrderByCondition>? orderBy;
  final int? limit;

  FindOptions({this.where, this.orderBy, this.limit});
}

/// Adaptador para Firebase Firestore, gerencia internamente a instância do banco.
///
/// Usa [WriteBatch] para operações atômicas (insert/update/delete).
/// Você pode instanciar com:
/// ```dart
/// final adapter = FirebaseAdapter<User>('users');
/// ```
class FirebaseAdapter<T extends Entity> {
  static bool _initialized = false;
  static FirebaseFirestore? _db;

  final String _collectionName;
  late CollectionReference<Map<String, dynamic>> _ref;
  WriteBatch? _batch;
  final Set<DocumentReference> _pendingOperations = {};

  /// Inicializa o Firebase (somente uma vez) e cria o adaptador.
  FirebaseAdapter(this._collectionName) {
    _init();
  }

  /// Inicializa o Firebase se ainda não foi inicializado.
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await Firebase.initializeApp();
      _db = FirebaseFirestore.instance;
      _initialized = true;
    }
  }

  Future<void> _init() async {
    await _ensureInitialized();
    _ref = _db!.collection(_collectionName);
    _batch = _db!.batch();
  }

  /// Busca documentos com filtros, ordenação e limite.
  Future<List<Map<String, dynamic>>> find([FindOptions? options]) async {
    await _ensureInitialized();
    Query<Map<String, dynamic>> query = _ref;

    if (options?.where != null) {
      for (var c in options!.where!) {
        query = query.where(c.field, isEqualTo: c.value); // simplificado
      }
    }

    if (options?.orderBy != null) {
      for (var order in options!.orderBy!) {
        query = query.orderBy(order.field, descending: order.descending);
      }
    }

    if (options?.limit != null) {
      query = query.limit(options!.limit!);
    }

    final snap = await query.get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  /// Busca um documento pelo ID.
  Future<Map<String, dynamic>?> findById(String id) async {
    await _ensureInitialized();
    final doc = await _ref.doc(id).get();
    if (doc.exists) return {'id': doc.id, ...doc.data()!};
    return null;
  }

  /// Insere um novo documento.
  Future<Map<String, dynamic>> insert(T object) async {
    await _ensureInitialized();
    final data = object.toMap()..['createdAt'] = FieldValue.serverTimestamp();
    final docRef = _ref.doc();
    await _batch!.set(docRef, data);
    _addOperation(docRef);
    return {'id': docRef.id, ...data};
  }

  /// Atualiza um documento existente.
  Future<void> update(String id, T object) async {
    await _ensureInitialized();
    final data = object.toMap()..['updatedAt'] = FieldValue.serverTimestamp();
    data.remove('id');
    final docRef = _ref.doc(id);
    await _batch!.update(docRef, data);
    _addOperation(docRef);
  }

  /// Remove um documento pelo ID.
  Future<void> delete(String id) async {
    await _ensureInitialized();
    final docRef = _ref.doc(id);
    await _batch!.delete(docRef);
    _addOperation(docRef);
  }

  /// Busca múltiplos documentos por IDs.
  Future<List<Map<String, dynamic>>> findByIds(List<String> ids) async {
    await _ensureInitialized();
    if (ids.isEmpty) return [];

    const chunkSize = 10;
    final chunks = <List<String>>[];
    for (var i = 0; i < ids.length; i += chunkSize) {
      chunks.add(
        ids.sublist(i, i + chunkSize > ids.length ? ids.length : i + chunkSize),
      );
    }

    final results = await Future.wait(
      chunks.map(
        (chunk) => _ref.where(FieldPath.documentId, whereIn: chunk).get(),
      ),
    );

    return results
        .expand((snap) => snap.docs)
        .map((d) => {'id': d.id, ...d.data()})
        .toList();
  }

  /// Confirma as operações em lote (commit).
  Future<void> commit() async {
    if (_pendingOperations.isNotEmpty) {
      await _batch!.commit();
      _batch = _db!.batch();
      _pendingOperations.clear();
    }
  }

  /// Cancela operações pendentes (rollback).
  Future<void> rollback() async {
    _batch = _db!.batch();
    _pendingOperations.clear();
  }

  /// Verifica se o Firestore está acessível.
  Future<void> healthCheck() async {
    await _ensureInitialized();
    await _db!.listCollections();
  }

  void _addOperation(DocumentReference ref) => _pendingOperations.add(ref);
}
