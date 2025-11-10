import 'package:flutter_test/flutter_test.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';

void main() {
  group('Card Entity', () {
    test('toMap retorna mapa com todos os campos corretos', () {
      final now = DateTime.now();

      final card = TaskEntity(
        id: 'abc123',
        title: 'Estudar Flutter',
        desc: 'Aprender widgets principais',
        tagName: 'estudo',
        time: 60,
        daysToExpire: 7,
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
      );

      final map = card.toMap();

      expect(map['id'], equals('abc123'));
      expect(map['title'], equals('Estudar Flutter'));
      expect(map['desc'], equals('Aprender widgets principais'));
      expect(map['tagName'], equals('estudo'));
      expect(map['time'], equals(60));
      expect(map['daysToExpire'], equals(7));
      expect(map['updatedAt'], equals(now.toIso8601String()));
      expect(map['createdAt'], equals(now.toIso8601String()));
    });

    test('fromMap cria Card corretamente a partir de mapa', () {
      final now = DateTime.now();

      final map = {
        'id': 'c1',
        'title': 'Revisar Dart',
        'desc': 'Estudar classes e herança',
        'tagName': 'dart',
        'time': 45,
        'daysToExpire': 5,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      final card = TaskEntity.fromMap(map);

      expect(card.id, equals('c1'));
      expect(card.title, equals('Revisar Dart'));
      expect(card.desc, equals('Estudar classes e herança'));
      expect(card.tagName, equals('dart'));
      expect(card.time, equals(45));
      expect(card.daysToExpire, equals(5));
    });

    test('remainingDaysToExpire retorna 0 se o card expirou', () {
      final createdAt = DateTime.now()
          .subtract(const Duration(days: 10))
          .toIso8601String();
      final card = TaskEntity(
        title: 'Expirado',
        desc: 'Já passou',
        tagName: 'velho',
        time: 30,
        daysToExpire: 5,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      expect(card.remainingDaysToExpire, equals(0));
    });

    test('remainingDaysToExpire retorna dias restantes positivos', () {
      final createdAt = DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String();
      final card = TaskEntity(
        title: 'Válido',
        desc: 'Ainda dentro do prazo',
        tagName: 'novo',
        time: 30,
        daysToExpire: 10,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final remaining = card.remainingDaysToExpire;
      expect(remaining, inInclusiveRange(7, 8)); // margem de 1 dia
    });

    test('expirationPercentage retorna 100% se já expirado', () {
      final createdAt = DateTime.now()
          .subtract(const Duration(days: 8))
          .toIso8601String();
      final card = TaskEntity(
        title: 'Expirado',
        desc: 'Tempo acabou',
        tagName: 'antigo',
        time: 30,
        daysToExpire: 5,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      expect(card.expirationPercentage, equals(100.0));
    });

    test(
      'expirationPercentage retorna 0% se criado agora e diasToExpire > 0',
      () {
        final createdAt = DateTime.now().toIso8601String();
        final card = TaskEntity(
          title: 'Novo',
          desc: 'Recém criado',
          tagName: 'atual',
          time: 10,
          daysToExpire: 10,
          createdAt: createdAt,
          updatedAt: createdAt,
        );

        expect(card.expirationPercentage, equals(0.0));
      },
    );

    test('expirationPercentage calcula corretamente progresso parcial', () {
      final createdAt = DateTime.now()
          .subtract(const Duration(days: 5))
          .toIso8601String();
      final card = TaskEntity(
        title: 'Progresso',
        desc: 'Em andamento',
        tagName: 'teste',
        time: 50,
        daysToExpire: 10,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      // 5 dias de 10 passados = 50%
      expect(card.expirationPercentage, closeTo(50.0, 10.0));
    });

    test('expirationPercentage retorna 100% se daysToExpire <= 0', () {
      final createdAt = DateTime.now().toIso8601String();
      final card = TaskEntity(
        title: 'Sem validade',
        desc: 'DaysToExpire zero',
        tagName: 'erro',
        time: 10,
        daysToExpire: 0,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      expect(card.expirationPercentage, equals(100.0));
    });
  });
}
