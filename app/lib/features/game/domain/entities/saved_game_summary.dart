import 'game_type.dart';

/// Kaydedilmiş oyun özeti.
class SavedGameSummary {
  const SavedGameSummary({
    required this.id,
    required this.leagueId,
    required this.playerCount,
    required this.gameType,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String? leagueId;
  final int playerCount;
  final GameType gameType;
  final String status;
  final DateTime? createdAt;
}
