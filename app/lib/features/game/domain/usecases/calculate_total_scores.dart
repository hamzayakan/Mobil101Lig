import '../entities/round_entity.dart';
import '../services/score_calculator.dart';

/// Toplam skor hesaplama use case'i.
class CalculateTotalScoresUseCase {
  CalculateTotalScoresUseCase(this._calculator);

  final ScoreCalculator _calculator;

  /// Tüm ellerden oyuncu bazlı toplam skorları hesaplar.
  Map<String, int> execute({
    required List<RoundEntity> rounds,
    required List<String> playerIds,
  }) {
    return _calculator.calculateTotals(rounds, playerIds);
  }
}
