import 'player_entity.dart';
import 'team_entity.dart';

/// Oyun sonucu: toplam skorlar ve kazanan/kaybeden bilgisi.
class GameResult {
  const GameResult({
    required this.totalScores,
    required this.winners,
    required this.losers,
    this.teamScores = const {},
    this.winningTeams = const [],
    this.losingTeams = const [],
  });

  /// playerId -> toplam skor
  final Map<String, int> totalScores;
  final List<PlayerEntity> winners;
  final List<PlayerEntity> losers;

  /// teamId -> takım toplam skoru (eşli mod)
  final Map<String, int> teamScores;
  final List<TeamEntity> winningTeams;
  final List<TeamEntity> losingTeams;
}
