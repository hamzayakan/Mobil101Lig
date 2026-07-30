import '../entities/game_result.dart';
import '../repositories/game_repository.dart';
import 'determine_winner.dart';

/// Oyun sonucunu (toplam + kazanan/kaybeden) döndürür.
class GetGameResultUseCase {
  GetGameResultUseCase(this._repository, this._determineWinner);

  final GameRepository _repository;
  final DetermineWinnerUseCase _determineWinner;

  /// Aktif oyun için güncel sonucu hesaplar.
  Future<GameResult?> execute() async {
    final game = await _repository.getCurrentGame();
    if (game == null) {
      return null;
    }

    final rounds = await _repository.getRounds();
    return _determineWinner.execute(game: game, rounds: rounds);
  }
}
