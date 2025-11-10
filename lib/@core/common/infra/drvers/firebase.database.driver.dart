// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';

// /// Adaptador para Firebase Firestore, gerencia internamente a instância do banco.
// ///
// /// Usa [WriteBatch] para operações atômicas (insert/update/delete).
// /// Você pode instanciar com:
// /// ```dart
// /// final adapter = FirebaseAdapter<User>('users');
// /// ```
// class FirebaseAdapter<T extends Map<String, dynamic>>
//     implements DatabaseAdapterI<T> {
//   late FirebaseFirestore _db;

//   final String _collectionName;
//   int _pendingOperations = 0;

//   late WriteBatch _batch;
//   late CollectionReference<Map<String, dynamic>> _ref;

//   FirebaseAdapter(this._collectionName) {
//     _db = FirebaseFirestore.instance;
//     _ref = _db.collection(_collectionName);
//     _batch = _db.batch();
//   }

//   @override
//   Future<List<T>> find(DatabaseAdapterFindOptions? options) async {
//     Query<Map<String, dynamic>> query = _ref;
//     final options_ = options as FindOptions?;

//     if (options_?.where != null) {
//       for (var c in options!.where!) {
//         query = query.where(c.field, isEqualTo: c.value); // simplificado
//       }
//     }

//     if (options?.orderBy != null) {
//       for (var order in options!.orderBy!) {
//         query = query.orderBy(order.field, descending: order.descending);
//       }
//     }

//     if (options?.limit != null) {
//       query = query.limit(options!.limit!);
//     }

//     final snap = await query.get();
//     return snap.docs.map((doc) => {...doc.data(), 'id': doc.id} as T).toList();
//   }

//   @override
//   Future<T?> findById(String id, DatabaseAdapterFindOptions? options) async {
//     final doc = await _ref.doc(id).get();
//     if (doc.exists) {
//       return {...?doc.data(), 'id': doc.id} as T;
//     }

//     return null;
//   }

//   @override
//   Future<T> insert(T object) async {
//     final data = {...object};
//     data.remove('id');

//     final docRef = _ref.doc();
//     _batch.set(docRef, data);
//     _addOperation();
//     return {...data, 'id': docRef.id} as T;
//   }

//   @override
//   Future<void> update(String id, T object) async {
//     final data = {...object};
//     data.remove('id');

//     final docRef = _ref.doc(id);
//     _batch.update(docRef, data);
//     _addOperation();
//   }

//   @override
//   Future<void> delete(String id) async {
//     final docRef = _ref.doc(id);
//     _batch.delete(docRef);
//     _addOperation();
//   }

//   @override
//   Future<List<T>> findByIds(
//     List<String> ids,
//     DatabaseAdapterFindOptions? options,
//   ) async {
//     if (ids.isEmpty) return [];

//     const chunkSize = 10;
//     final chunks = <List<String>>[];

//     for (var i = 0; i < ids.length; i += chunkSize) {
//       chunks.add(
//         ids.sublist(i, i + chunkSize > ids.length ? ids.length : i + chunkSize),
//       );
//     }

//     final results = await Future.wait(
//       chunks.map(
//         (chunk) => _ref.where(FieldPath.documentId, whereIn: chunk).get(),
//       ),
//     );

//     return results
//         .expand((snap) => snap.docs)
//         .map((d) => {...d.data(), 'id': d.id} as T)
//         .toList();
//   }

//   @override
//   Future<void> commit() async {
//     if (_pendingOperations > 0) {
//       await _batch.commit();
//       _batch = _db.batch();
//       _clearOperation();
//     }
//   }

//   @override
//   Future<void> rollback() async {
//     _batch = _db.batch();
//     _clearOperation();
//   }

//   @override
//   Future<void> healthCheck() async {
//     await _ref.limit(1).get();
//   }

//   void _addOperation() => _pendingOperations++;
//   void _clearOperation() => _pendingOperations = 0;
// }

// class FirebaseAdapterException implements Exception {
//   final String message;
//   final int? code;

//   FirebaseAdapterException(this.message, {this.code});

//   @override
//   String toString() {
//     return "FirebaseAdapterException: $message (code: ${code ?? 'no code'})";
//   }
// }

// /// Representa uma condição de filtro (WHERE)
// class FilterCondition {
//   final String field;
//   final String operator;
//   final dynamic value;

//   FilterCondition({
//     required this.field,
//     required this.operator,
//     required this.value,
//   });
// }

// /// Representa uma condição de ordenação (ORDER BY)
// class OrderByCondition {
//   final String field;
//   final bool descending;

//   OrderByCondition({required this.field, this.descending = false});
// }

// /// Opções de busca (WHERE, ORDER BY, LIMIT)
// class FindOptions extends DatabaseAdapterFindOptions {
//   final int? limit;
//   final List<FilterCondition>? where;
//   final List<OrderByCondition>? orderBy;

//   FindOptions({this.where, this.orderBy, this.limit});
// }
