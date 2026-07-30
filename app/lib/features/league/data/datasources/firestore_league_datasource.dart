import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/league_exception.dart';
import '../../../../services/firebase/firebase_initializer.dart';
import '../models/league_member_model.dart';
import '../models/league_model.dart';

/// Firestore lig veri kaynağı.
class FirestoreLeagueDataSource {
  FirestoreLeagueDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _leaguesCollection = 'leagues';
  static const _membersCollection = 'league_members';

  Future<LeagueModel> createLeague({
    required String name,
    required String ownerId,
    required String ownerDisplayName,
  }) async {
    _ensureConfigured();

    final leagueRef = _firestore.collection(_leaguesCollection).doc();
    final memberId = LeagueMemberModel.documentId(leagueRef.id, ownerId);
    final memberRef = _firestore.collection(_membersCollection).doc(memberId);

    final league = LeagueModel(
      id: leagueRef.id,
      name: name,
      ownerId: ownerId,
      maxPlayers: 20,
      status: 'active',
    );

    final member = LeagueMemberModel(
      id: memberId,
      leagueId: leagueRef.id,
      userId: ownerId,
      displayName: ownerDisplayName,
    );

    try {
      await _firestore.runTransaction((transaction) async {
        transaction.set(
          leagueRef,
          league.toFirestore(createdAt: FieldValue.serverTimestamp()),
        );
        transaction.set(
          memberRef,
          member.toFirestore(joinedAt: FieldValue.serverTimestamp()),
        );
      });
    } catch (error) {
      throw LeagueException('Lig oluşturulamadı: $error');
    }

    final snapshot = await leagueRef.get();
    return LeagueModel.fromFirestore(snapshot);
  }

  Future<List<LeagueModel>> getUserLeagues(String userId) async {
    _ensureConfigured();

    final memberQuery = await _firestore
        .collection(_membersCollection)
        .where('userId', isEqualTo: userId)
        .get();

    if (memberQuery.docs.isEmpty) {
      return [];
    }

    final leagueIds = memberQuery.docs
        .map((doc) => doc.data()['leagueId'] as String? ?? '')
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final leagues = <LeagueModel>[];
    for (final leagueId in leagueIds) {
      final doc = await _firestore.collection(_leaguesCollection).doc(leagueId).get();
      if (doc.exists) {
        leagues.add(LeagueModel.fromFirestore(doc));
      }
    }

    leagues.sort(
      (a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)),
    );
    return leagues;
  }

  Future<List<LeagueMemberModel>> getLeagueMembers(String leagueId) async {
    _ensureConfigured();

    final query = await _firestore
        .collection(_membersCollection)
        .where('leagueId', isEqualTo: leagueId)
        .get();

    final members = query.docs.map(LeagueMemberModel.fromFirestore).toList();
    members.sort((a, b) {
      final scoreCompare = a.totalScore.compareTo(b.totalScore);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      return a.displayName.compareTo(b.displayName);
    });
    return members;
  }

  Future<LeagueModel?> getLeague(String leagueId) async {
    _ensureConfigured();

    final doc = await _firestore.collection(_leaguesCollection).doc(leagueId).get();
    if (!doc.exists) {
      return null;
    }
    return LeagueModel.fromFirestore(doc);
  }

  Future<void> addMember({
    required String leagueId,
    required String userId,
    required String displayName,
  }) async {
    _ensureConfigured();

    final memberId = LeagueMemberModel.documentId(leagueId, userId);
    final existing = await _firestore
        .collection(_membersCollection)
        .doc(memberId)
        .get();

    if (existing.exists) {
      throw LeagueException('Bu kullanıcı zaten lig üyesi.');
    }

    final members = await getLeagueMembers(leagueId);
    final league = await getLeague(leagueId);
    if (league != null && members.length >= league.maxPlayers) {
      throw LeagueException('Lig oyuncu limitine ulaştı.');
    }

    final member = LeagueMemberModel(
      id: memberId,
      leagueId: leagueId,
      userId: userId,
      displayName: displayName,
    );

    try {
      await _firestore.collection(_membersCollection).doc(memberId).set(
            member.toFirestore(joinedAt: FieldValue.serverTimestamp()),
          );
    } catch (error) {
      throw LeagueException('Üye eklenemedi: $error');
    }
  }

  Future<void> applyGameScores({
    required String leagueId,
    required Map<String, int> scoresByUserId,
  }) async {
    _ensureConfigured();

    if (scoresByUserId.isEmpty) {
      return;
    }

    await _firestore.runTransaction((transaction) async {
      for (final entry in scoresByUserId.entries) {
        final memberId = LeagueMemberModel.documentId(leagueId, entry.key);
        final memberRef = _firestore.collection(_membersCollection).doc(memberId);
        final snapshot = await transaction.get(memberRef);

        if (!snapshot.exists) {
          continue;
        }

        final data = snapshot.data() ?? {};
        final currentScore = (data['totalScore'] as num?)?.toInt() ?? 0;
        final gamesPlayed = (data['gamesPlayed'] as num?)?.toInt() ?? 0;

        transaction.update(memberRef, {
          'totalScore': currentScore + entry.value,
          'gamesPlayed': gamesPlayed + 1,
        });
      }
    });
  }

  void _ensureConfigured() {
    if (!FirebaseInitializer.isInitialized) {
      throw FirestoreNotConfiguredException();
    }
  }
}
