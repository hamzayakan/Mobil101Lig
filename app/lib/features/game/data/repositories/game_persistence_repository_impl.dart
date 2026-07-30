import '../../../league/domain/entities/league_member_entity.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/round_entity.dart';
import '../../domain/entities/saved_game_summary.dart';
import '../../domain/repositories/game_persistence_repository.dart';
import '../datasources/firestore_game_datasource.dart';
import '../../../league/domain/repositories/league_repository.dart';

/// Firestore oyun kalıcılığı implementasyonu.
class GamePersistenceRepositoryImpl implements GamePersistenceRepository {
  GamePersistenceRepositoryImpl({
    required FirestoreGameDataSource gameDataSource,
    required LeagueRepository leagueRepository,
  })  : _gameDataSource = gameDataSource,
        _leagueRepository = leagueRepository;

  final FirestoreGameDataSource _gameDataSource;
  final LeagueRepository _leagueRepository;

  @override
  Future<String> saveCompletedGame({
    required GameEntity game,
    required List<RoundEntity> rounds,
    required GameResult result,
    required List<LeagueMemberEntity> leagueMembers,
  }) async {
    final gameId = await _gameDataSource.saveCompletedGame(
      game: game,
      rounds: rounds,
      totalScores: result.totalScores,
    );

    final leagueId = game.leagueId;
    if (leagueId != null) {
      final scoresByUserId = _mapScoresToUsers(
        game: game,
        result: result,
        leagueMembers: leagueMembers,
      );
      await _leagueRepository.applyGameScores(
        leagueId: leagueId,
        scoresByUserId: scoresByUserId,
      );
    }

    return gameId;
  }

  @override
  Future<List<SavedGameSummary>> getLeagueGames(String leagueId) {
    return _gameDataSource.getLeagueGames(leagueId);
  }

  Map<String, int> _mapScoresToUsers({
    required GameEntity game,
    required GameResult result,
    required List<LeagueMemberEntity> leagueMembers,
  }) {
    final scores = <String, int>{};

    for (final player in game.players) {
      final score = result.totalScores[player.id] ?? 0;
      final userId = player.userId ?? _findUserIdByName(player.name, leagueMembers);
      if (userId != null) {
        scores[userId] = score;
      }
    }

    return scores;
  }

  String? _findUserIdByName(
    String name,
    List<LeagueMemberEntity> members,
  ) {
    final normalized = name.trim().toLowerCase();
    for (final member in members) {
      if (member.displayName.trim().toLowerCase() == normalized) {
        return member.userId;
      }
    }
    return null;
  }
}
