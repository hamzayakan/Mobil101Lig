/// Oyuncu domain nesnesi.
class PlayerEntity {
  const PlayerEntity({
    required this.id,
    this.userId,
    required this.name,
    this.totalScore = 0,
  });

  /// Oyun içi slot kimliği.
  final String id;

  /// Firebase Auth uid; MVP'de null (misafir oyuncu).
  final String? userId;

  final String name;
  final int totalScore;

  PlayerEntity copyWith({
    String? id,
    String? userId,
    String? name,
    int? totalScore,
  }) {
    return PlayerEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      totalScore: totalScore ?? this.totalScore,
    );
  }
}
