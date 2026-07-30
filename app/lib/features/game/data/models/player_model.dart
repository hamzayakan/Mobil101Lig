import '../../domain/entities/player_entity.dart';

/// Oyuncu veri modeli.
class PlayerModel {
  const PlayerModel({
    required this.id,
    this.userId,
    required this.name,
    this.totalScore = 0,
  });

  final String id;
  final String? userId;
  final String name;
  final int totalScore;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      totalScore: json['totalScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'totalScore': totalScore,
    };
  }

  PlayerEntity toEntity() {
    return PlayerEntity(
      id: id,
      userId: userId,
      name: name,
      totalScore: totalScore,
    );
  }

  factory PlayerModel.fromEntity(PlayerEntity entity) {
    return PlayerModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      totalScore: entity.totalScore,
    );
  }
}
