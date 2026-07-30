/// Bir el (round) domain nesnesi.
class RoundEntity {
  const RoundEntity({
    required this.roundNumber,
    required this.playerScores,
  });

  final int roundNumber;

  /// playerId -> el skoru
  final Map<String, int> playerScores;

  RoundEntity copyWith({
    int? roundNumber,
    Map<String, int>? playerScores,
  }) {
    return RoundEntity(
      roundNumber: roundNumber ?? this.roundNumber,
      playerScores: playerScores ?? this.playerScores,
    );
  }
}
