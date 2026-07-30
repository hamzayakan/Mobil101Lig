import 'package:app/features/game/domain/entities/game_entity.dart';
import 'package:app/features/game/domain/entities/game_type.dart';
import 'package:app/features/game/domain/entities/player_entity.dart';
import 'package:app/features/game/domain/entities/round_entity.dart';
import 'package:app/features/game/domain/entities/team_entity.dart';
import 'package:app/features/game/domain/services/default_score_calculator.dart';
import 'package:app/features/game/domain/usecases/determine_winner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DetermineWinnerUseCase useCase;

  setUp(() {
    useCase = DetermineWinnerUseCase(DefaultScoreCalculator());
  });

  group('DetermineWinnerUseCase', () {
    test('tekli modda kazanan oyuncu belirleme', () {
      const game = GameEntity(
        id: 'g1',
        gameType: GameType.single,
        players: [
          PlayerEntity(id: 'ali', name: 'Ali'),
          PlayerEntity(id: 'mehmet', name: 'Mehmet'),
          PlayerEntity(id: 'ahmet', name: 'Ahmet'),
          PlayerEntity(id: 'hasan', name: 'Hasan'),
        ],
      );

      const rounds = [
        RoundEntity(
          roundNumber: 1,
          playerScores: {
            'ali': 20,
            'mehmet': 40,
            'ahmet': 0,
            'hasan': 15,
          },
        ),
        RoundEntity(
          roundNumber: 2,
          playerScores: {
            'ali': 10,
            'mehmet': -5,
            'ahmet': 30,
            'hasan': 0,
          },
        ),
      ];

      final result = useCase.execute(game: game, rounds: rounds);

      expect(result.winners.single.id, 'hasan');
      expect(result.totalScores['hasan'], 15);
    });

    test('eşli modda manuel takım ile kazanan takım belirleme', () {
      const game = GameEntity(
        id: 'g2',
        gameType: GameType.team,
        players: [
          PlayerEntity(id: 'ali', name: 'Ali'),
          PlayerEntity(id: 'mehmet', name: 'Mehmet'),
          PlayerEntity(id: 'ahmet', name: 'Ahmet'),
          PlayerEntity(id: 'hasan', name: 'Hasan'),
        ],
        teams: [
          TeamEntity(
            id: 'team_a',
            name: 'Takım A',
            playerIds: ['ali', 'hasan'],
          ),
          TeamEntity(
            id: 'team_b',
            name: 'Takım B',
            playerIds: ['mehmet', 'ahmet'],
          ),
        ],
      );

      const rounds = [
        RoundEntity(
          roundNumber: 1,
          playerScores: {
            'ali': 20,
            'mehmet': 40,
            'ahmet': 0,
            'hasan': 15,
          },
        ),
        RoundEntity(
          roundNumber: 2,
          playerScores: {
            'ali': 10,
            'mehmet': -5,
            'ahmet': 30,
            'hasan': 0,
          },
        ),
      ];

      final result = useCase.execute(game: game, rounds: rounds);

      expect(result.teamScores['team_a'], 45);
      expect(result.teamScores['team_b'], 65);
      expect(result.winningTeams.single.id, 'team_a');
      expect(result.losingTeams.single.id, 'team_b');
      expect(result.winners.map((p) => p.id), containsAll(['ali', 'hasan']));
    });
  });
}
