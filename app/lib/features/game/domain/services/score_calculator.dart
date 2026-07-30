import '../entities/game_result.dart';
import '../entities/game_type.dart';
import '../entities/player_entity.dart';
import '../entities/round_entity.dart';
import '../entities/team_entity.dart';

/// Skor hesaplama servisi arayüzü.
abstract class ScoreCalculator {
  /// Tüm el skorlarından oyuncu bazlı toplam skorları hesaplar.
  Map<String, int> calculateTotals(
    List<RoundEntity> rounds,
    List<String> playerIds,
  );

  /// Tekli veya eşli modda kazanan/kaybeden belirler.
  GameResult determineResult({
    required Map<String, int> totalScores,
    required GameType gameType,
    required List<PlayerEntity> players,
    required List<TeamEntity>? teams,
  });
}
