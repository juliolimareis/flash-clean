import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';
import 'package:flash_clean/@core/common/infra/database/interface/database.adapter.interface.dart';
import 'package:flash_clean/@core/task/infra/task.repository.dart';

class MockDatabaseAdapter extends Mock
    implements DatabaseAdapterI<Map<String, dynamic>> {}

void main() {
  late MockDatabaseAdapter adapter;
  late TaskRepository repository;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    adapter = MockDatabaseAdapter();
    repository = TaskRepository(adapter: adapter);
  });

  group('CardRepository', () {
    final mockMap = {
      'id': '1',
      'title': 'Estudar Flutter',
      'desc': 'Revisar widgets principais',
      'tagName': 'estudos',
      'time': 120,
      'daysToExpire': 10,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    test('fetch retorna lista de Cards corretamente', () async {
      when(() => adapter.find(any())).thenAnswer((_) async => [mockMap]);

      final result = await repository.fetch(null);

      expect(result, isA<List<TaskEntity>>());
      expect(result.first.title, equals('Estudar Flutter'));
      expect(result.first.daysToExpire, equals(10));

      verify(() => adapter.find(any())).called(1);
    });

    test('fetchById retorna Card quando encontrado', () async {
      when(() => adapter.findById('1', any())).thenAnswer((_) async => mockMap);

      final result = await repository.fetchById('1');

      expect(result, isA<TaskEntity>());
      expect(result?.title, equals('Estudar Flutter'));
      verify(() => adapter.findById('1', any())).called(1);
    });

    test('fetchByIds retorna lista de Cards', () async {
      when(
        () => adapter.findByIds(['1'], any()),
      ).thenAnswer((_) async => [mockMap]);

      final result = await repository.fetchByIds(['1']);

      expect(result.length, 1);
      expect(result.first.tagName, equals('estudos'));
    });

    test('create insere e comita corretamente', () async {
      final card = TaskEntity(
        id: '1',
        title: 'Criar Card',
        desc: 'Descrição teste',
        tagName: 'tag1',
        time: 100,
        daysToExpire: 5,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      when(() => adapter.insert(any())).thenAnswer((_) async => card.toMap());
      when(() => adapter.commit()).thenAnswer((_) async {});

      final result = await repository.create(card);

      expect(result.title, equals('Criar Card'));
      verify(() => adapter.insert(any())).called(1);
      verify(() => adapter.commit()).called(1);
    });

    test('update lança exceção se ID estiver ausente', () async {
      final card = TaskEntity(
        title: 'Sem ID',
        desc: 'Erro esperado',
        tagName: 'tag1',
        time: 20,
        daysToExpire: 2,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      expect(
        () => repository.update(card),
        throwsA(isA<CardRepositoryException>()),
      );
    });

    test('remove deleta e comita corretamente', () async {
      when(() => adapter.delete('1')).thenAnswer((_) async {});
      when(() => adapter.commit()).thenAnswer((_) async {});

      await repository.remove('1');

      verify(() => adapter.delete('1')).called(1);
      verify(() => adapter.commit()).called(1);
    });
  });
}
