import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/league_member_entity.dart';

/// Firestore lig üyesi modeli.
class LeagueMemberModel {
  const LeagueMemberModel({
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

  factory LeagueMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return LeagueMemberModel(
      id: doc.id,
      leagueId: data['leagueId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      totalScore: (data['totalScore'] as num?)?.toInt() ?? 0,
      gamesPlayed: (data['gamesPlayed'] as num?)?.toInt() ?? 0,
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore({FieldValue? joinedAt}) {
    return {
      'leagueId': leagueId,
      'userId': userId,
      'displayName': displayName,
      'totalScore': totalScore,
      'gamesPlayed': gamesPlayed,
      'joinedAt': joinedAt ?? Timestamp.fromDate(joinedAtDate),
    };
  }

  DateTime get joinedAtDate => joinedAt ?? DateTime.now();

  LeagueMemberEntity toEntity() {
    return LeagueMemberEntity(
      id: id,
      leagueId: leagueId,
      userId: userId,
      displayName: displayName,
      totalScore: totalScore,
      gamesPlayed: gamesPlayed,
      joinedAt: joinedAt,
    );
  }

  static String documentId(String leagueId, String userId) =>
      '${leagueId}_$userId';
}
