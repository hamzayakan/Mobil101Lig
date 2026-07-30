import '../entities/round_entity.dart';
import '../repositories/game_repository.dart';

/// El güncelleme use case'i.
class UpdateRoundUseCase {
  UpdateRoundUseCase(this._repository);

  final GameRepository _repository;

  /// Verilen el numarasının skorlarını günceller.
  Future<RoundEntity> execute({
    required int roundNumber,
    required Map<String, int> playerScores,
  }) {
    return _repository.updateRound(
      roundNumber: roundNumber,
      playerScores: playerScores,
    );
  }
}
