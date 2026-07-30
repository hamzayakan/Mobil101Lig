import '../entities/round_entity.dart';
import '../repositories/game_repository.dart';

/// Yeni el ekleme use case'i.
class AddRoundUseCase {
  AddRoundUseCase(this._repository);

  final GameRepository _repository;

  /// Verilen skorlarla yeni el ekler.
  Future<RoundEntity> execute(Map<String, int> playerScores) {
    return _repository.addRound(playerScores);
  }
}
