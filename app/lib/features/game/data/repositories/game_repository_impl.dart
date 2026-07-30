import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_type.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/round_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/local_game_datasource.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../models/round_model.dart';
import '../models/team_model.dart';

/// Yerel oyun repository implementasyonu.
class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._dataSource);

  final LocalGameDataSource _dataSource;

  @override
  Future<GameEntity> createGame({
    required List<PlayerEntity> players,
    required GameType gameType,
    String? createdByUserId,
    String? leagueId,
  }) async {
    _dataSource.clear();

    final game = GameModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      players: players.map(PlayerModel.fromEntity).toList(),
      gameType: gameType,
      createdByUserId: createdByUserId,
      leagueId: leagueId,
    );

    _dataSource.saveGame(game);
    return game.toEntity();
  }

  @override
  Future<GameEntity> assignTeams(List<TeamEntity> teams) async {
    final updated = _dataSource.assignTeams(
      teams.map(TeamModel.fromEntity).toList(),
    );
    return updated.toEntity();
  }

  @override
  Future<RoundEntity> addRound(Map<String, int> playerScores) async {
    if (_dataSource.currentGame == null) {
      throw StateError('Aktif oyun bulunamadı.');
    }

    final round = RoundModel(
      roundNumber: _dataSource.rounds.length + 1,
      playerScores: Map<String, int>.from(playerScores),
    );

    _dataSource.addRound(round);
    return round.toEntity();
  }

  @override
  Future<RoundEntity> updateRound({
    required int roundNumber,
    required Map<String, int> playerScores,
  }) async {
    if (_dataSource.currentGame == null) {
      throw StateError('Aktif oyun bulunamadı.');
    }

    final round = _dataSource.updateRound(
      roundNumber,
      Map<String, int>.from(playerScores),
    );
    return round.toEntity();
  }

  @override
  Future<void> deleteRound(int roundNumber) async {
    if (_dataSource.currentGame == null) {
      throw StateError('Aktif oyun bulunamadı.');
    }
    _dataSource.deleteRound(roundNumber);
  }

  @override
  Future<GameEntity?> getCurrentGame() async {
    return _dataSource.currentGame?.toEntity();
  }

  @override
  Future<List<RoundEntity>> getRounds() async {
    return _dataSource.rounds.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> clear() async {
    _dataSource.clear();
  }
}
