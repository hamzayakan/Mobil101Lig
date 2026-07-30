/// Takım domain nesnesi (eşli oyun).
class TeamEntity {
  const TeamEntity({
    required this.id,
    required this.name,
    required this.playerIds,
  });

  final String id;
  final String name;
  final List<String> playerIds;

  TeamEntity copyWith({
    String? id,
    String? name,
    List<String>? playerIds,
  }) {
    return TeamEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      playerIds: playerIds ?? this.playerIds,
    );
  }
}
