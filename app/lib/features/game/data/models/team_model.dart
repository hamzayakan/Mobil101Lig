import '../../domain/entities/team_entity.dart';

/// Takım veri modeli.
class TeamModel {
  const TeamModel({
    required this.id,
    required this.name,
    required this.playerIds,
  });

  final String id;
  final String name;
  final List<String> playerIds;

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      playerIds: List<String>.from(json['playerIds'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'playerIds': playerIds,
    };
  }

  TeamEntity toEntity() {
    return TeamEntity(
      id: id,
      name: name,
      playerIds: playerIds,
    );
  }

  factory TeamModel.fromEntity(TeamEntity entity) {
    return TeamModel(
      id: entity.id,
      name: entity.name,
      playerIds: entity.playerIds,
    );
  }
}
