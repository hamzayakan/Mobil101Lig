/// Lig domain nesnesi.
class LeagueEntity {
  const LeagueEntity({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.maxPlayers,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String name;
  final String ownerId;
  final int maxPlayers;
  final String status;
  final DateTime? createdAt;
}
