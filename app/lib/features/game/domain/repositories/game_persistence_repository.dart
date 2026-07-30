import '../../../league/domain/entities/league_member_entity.dart';
import '../entities/game_entity.dart';
import '../entities/game_result.dart';
import '../entities/round_entity.dart';
import '../entities/saved_game_summary.dart';

/// Oyun kalıcılığı repository arayüzü.
abstract class GamePersistenceRepository {
  Future<String> saveCompletedGame({
    required GameEntity game,
    required List<RoundEntity> rounds,
    required GameResult result,
    required List<LeagueMemberEntity> leagueMembers,
  });

  Future<List<SavedGameSummary>> getLeagueGames(String leagueId);
}
