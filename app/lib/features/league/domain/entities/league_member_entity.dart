/// Lig üyesi domain nesnesi.
class LeagueMemberEntity {
  const LeagueMemberEntity({
    required this.id,
    required this.leagueId,
    required this.userId,
    required this.displayName,
    this.totalScore = 0,
    this.gamesPlayed = 0,
    this.joinedAt,
  });

  final String id;
  final String leagueId;
  final String userId;
  final String displayName;
  final int totalScore;
  final int gamesPlayed;
  final DateTime? joinedAt;
}
