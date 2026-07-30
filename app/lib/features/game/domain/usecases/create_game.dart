import '../entities/game_entity.dart';
import '../entities/game_type.dart';
import '../entities/player_entity.dart';
import '../repositories/game_repository.dart';

/// Yeni oyun oluşturma use case'i.
class CreateGameUseCase {
  CreateGameUseCase(this._repository);

  final GameRepository _repository;

  /// Verilen oyuncular ve oyun tipi ile yeni oyun başlatır.
  Future<GameEntity> execute({
    required List<PlayerEntity> players,
    required GameType gameType,
    String? createdByUserId,
    String? leagueId,
  }) {
    return _repository.createGame(
      players: players,
      gameType: gameType,
      createdByUserId: createdByUserId,
      leagueId: leagueId,
    );
  }
}
