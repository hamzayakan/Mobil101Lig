import '../entities/game_entity.dart';
import '../entities/game_type.dart';
import '../entities/player_entity.dart';
import '../entities/round_entity.dart';
import '../entities/team_entity.dart';

/// Oyun veri erişim arayüzü.
abstract class GameRepository {
  /// Yeni oyun oluşturur.
  Future<GameEntity> createGame({
    required List<PlayerEntity> players,
    required GameType gameType,
    String? createdByUserId,
    String? leagueId,
  });

  /// Manuel takım atamasını kaydeder.
  Future<GameEntity> assignTeams(List<TeamEntity> teams);

  /// Yeni el ekler.
  Future<RoundEntity> addRound(Map<String, int> playerScores);

  /// Belirtilen eli günceller.
  Future<RoundEntity> updateRound({
    required int roundNumber,
    required Map<String, int> playerScores,
  });

  /// Belirtilen eli siler ve kalan elleri yeniden numaralandırır.
  Future<void> deleteRound(int roundNumber);

  /// Aktif oyunu döndürür.
  Future<GameEntity?> getCurrentGame();

  /// Tüm elleri döndürür.
  Future<List<RoundEntity>> getRounds();

  /// Oturumu temizler.
  Future<void> clear();
}
