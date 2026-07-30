import 'package:app/features/game/domain/entities/game_entity.dart';
import 'package:app/features/game/domain/entities/game_result.dart';
import 'package:app/features/game/domain/entities/game_type.dart';
import 'package:app/features/game/domain/entities/round_entity.dart';
import 'package:app/features/game/domain/repositories/game_persistence_repository.dart';
import 'package:app/features/game/domain/entities/saved_game_summary.dart';
import 'package:app/features/game/domain/usecases/complete_and_save_game.dart';
import 'package:app/features/league/domain/entities/league_member_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGamePersistenceRepository implements GamePersistenceRepository {
  Map<String, int>? lastScoresByUserId;
  String? lastLeagueId;

  @override
  Future<String> saveCompletedGame({
    required GameEntity game,
    required List<RoundEntity> rounds,
    required GameResult result,
    required List<LeagueMemberEntity> leagueMembers,
  }) async {
    lastLeagueId = game.leagueId;
    return 'game1';
  }

  @override
  Future<List<SavedGameSummary>> getLeagueGames(String leagueId) async => [];
}

void main() {
  test('CompleteAndSaveGameUseCase en az bir el olmadan hata verir', () async {
    final useCase = CompleteAndSaveGameUseCase(_FakeGamePersistenceRepository());

    expect(
      () => useCase.execute(
        game: const GameEntity(
          id: '1',
          players: [],
          gameType: GameType.single,
          leagueId: 'league1',
        ),
        rounds: const [],
        result: const GameResult(
          totalScores: {},
          winners: [],
          losers: [],
        ),
        leagueMembers: const [],
      ),
      throwsArgumentError,
    );
  });
}
