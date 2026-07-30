import 'package:app/features/game/domain/entities/game_type.dart';
import 'package:app/features/game/domain/entities/player_entity.dart';
import 'package:app/features/game/domain/entities/round_entity.dart';
import 'package:app/features/game/domain/services/default_score_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DefaultScoreCalculator calculator;

  setUp(() {
    calculator = DefaultScoreCalculator();
  });

  group('DefaultScoreCalculator', () {
    test('4 oyunculu oyun sonucu hesaplama', () {
      const playerIds = ['ali', 'mehmet', 'ahmet', 'hasan'];
      final rounds = [
        const RoundEntity(
          roundNumber: 1,
          playerScores: {
            'ali': 20,
            'mehmet': 40,
            'ahmet': 0,
            'hasan': 15,
          },
        ),
        const RoundEntity(
          roundNumber: 2,
          playerScores: {
            'ali': 10,
            'mehmet': -5,
            'ahmet': 30,
            'hasan': 0,
          },
        ),
      ];

      final totals = calculator.calculateTotals(rounds, playerIds);

      expect(totals['ali'], 30);
      expect(totals['mehmet'], 35);
      expect(totals['ahmet'], 30);
      expect(totals['hasan'], 15);
    });

    test('13 ellik oyun sonucu hesaplama', () {
      const playerIds = ['p1', 'p2', 'p3', 'p4'];
      final rounds = List.generate(
        13,
        (index) => RoundEntity(
          roundNumber: index + 1,
          playerScores: {
            'p1': 10,
            'p2': 20,
            'p3': 5,
            'p4': 15,
          },
        ),
      );

      final totals = calculator.calculateTotals(rounds, playerIds);

      expect(totals['p1'], 130);
      expect(totals['p2'], 260);
      expect(totals['p3'], 65);
      expect(totals['p4'], 195);
    });

    test('negatif ve pozitif skor desteği', () {
      const playerIds = ['a', 'b'];
      final rounds = [
        const RoundEntity(
          roundNumber: 1,
          playerScores: {'a': -50, 'b': 120},
        ),
        const RoundEntity(
          roundNumber: 2,
          playerScores: {'a': 30, 'b': -20},
        ),
      ];

      final totals = calculator.calculateTotals(rounds, playerIds);

      expect(totals['a'], -20);
      expect(totals['b'], 100);
    });

    test('tekli modda kazanan en düşük skorlu oyuncu', () {
      const players = [
        PlayerEntity(id: 'ali', name: 'Ali'),
        PlayerEntity(id: 'mehmet', name: 'Mehmet'),
        PlayerEntity(id: 'ahmet', name: 'Ahmet'),
        PlayerEntity(id: 'hasan', name: 'Hasan'),
      ];

      final result = calculator.determineResult(
        totalScores: {
          'ali': 30,
          'mehmet': 35,
          'ahmet': 30,
          'hasan': 15,
        },
        gameType: GameType.single,
        players: players,
        teams: null,
      );

      expect(result.winners.map((p) => p.id), ['hasan']);
      expect(result.losers.map((p) => p.id), contains('mehmet'));
    });
  });
}
