import '../entities/game_entity.dart';
import '../entities/game_result.dart';
import '../entities/round_entity.dart';
import '../services/score_calculator.dart';

/// Kazanan/kaybeden belirleme use case'i.
class DetermineWinnerUseCase {
  DetermineWinnerUseCase(this._calculator);

  final ScoreCalculator _calculator;

  /// Oyun ve skor bilgisine göre sonucu belirler.
  GameResult execute({
    required GameEntity game,
    required List<RoundEntity> rounds,
  }) {
    final playerIds = game.players.map((p) => p.id).toList();
    final totalScores = _calculator.calculateTotals(rounds, playerIds);

    return _calculator.determineResult(
      totalScores: totalScores,
      gameType: game.gameType,
      players: game.players,
      teams: game.teams,
    );
  }
}
