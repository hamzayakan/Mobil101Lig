import '../../domain/entities/round_entity.dart';

/// El (round) veri modeli.
class RoundModel {
  const RoundModel({
    required this.roundNumber,
    required this.playerScores,
  });

  final int roundNumber;
  final Map<String, int> playerScores;

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    final scoresRaw = json['playerScores'] as Map<String, dynamic>;
    return RoundModel(
      roundNumber: json['roundNumber'] as int,
      playerScores: scoresRaw.map(
        (key, value) => MapEntry(key, value as int),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'playerScores': playerScores,
    };
  }

  RoundEntity toEntity() {
    return RoundEntity(
      roundNumber: roundNumber,
      playerScores: Map<String, int>.from(playerScores),
    );
  }

  factory RoundModel.fromEntity(RoundEntity entity) {
    return RoundModel(
      roundNumber: entity.roundNumber,
      playerScores: Map<String, int>.from(entity.playerScores),
    );
  }
}
