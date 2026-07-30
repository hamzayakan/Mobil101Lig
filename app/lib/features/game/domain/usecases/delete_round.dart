import '../repositories/game_repository.dart';

/// El silme use case'i.
class DeleteRoundUseCase {
  DeleteRoundUseCase(this._repository);

  final GameRepository _repository;

  /// Verilen el numarasını siler.
  Future<void> execute(int roundNumber) {
    return _repository.deleteRound(roundNumber);
  }
}
