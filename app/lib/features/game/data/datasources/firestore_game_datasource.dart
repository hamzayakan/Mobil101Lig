import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/firebase/firebase_initializer.dart';
import '../../domain/entities/game_type.dart';
import '../../domain/entities/saved_game_summary.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/round_entity.dart';

/// Firestore oyun veri kaynağı.
class FirestoreGameDataSource {
  FirestoreGameDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _gamesCollection = 'games';

  Future<String> saveCompletedGame({
    required GameEntity game,
    required List<RoundEntity> rounds,
    required Map<String, int> totalScores,
  }) async {
    _ensureConfigured();

    final gameRef = _firestore.collection(_gamesCollection).doc();
    final batch = _firestore.batch();

    batch.set(gameRef, {
      'leagueId': game.leagueId,
      'createdBy': game.createdByUserId,
      'gameType': game.gameType.name,
      'playerCount': game.players.length,
      'status': 'completed',
      'createdAt': FieldValue.serverTimestamp(),
      'players': game.players
          .map(
            (player) => {
              'playerId': player.id,
              'userId': player.userId,
              'name': player.name,
              'totalScore': totalScores[player.id] ?? 0,
            },
          )
          .toList(),
    });

    for (final round in rounds) {
      final roundRef = gameRef.collection('rounds').doc('${round.roundNumber}');
      batch.set(roundRef, {
        'roundNumber': round.roundNumber,
        'playerScores': round.playerScores,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    return gameRef.id;
  }

  Future<List<SavedGameSummary>> getLeagueGames(String leagueId) async {
    _ensureConfigured();

    final query = await _firestore
        .collection(_gamesCollection)
        .where('leagueId', isEqualTo: leagueId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return SavedGameSummary(
        id: doc.id,
        leagueId: data['leagueId'] as String?,
        playerCount: (data['playerCount'] as num?)?.toInt() ?? 0,
        gameType: _parseGameType(data['gameType'] as String?),
        status: data['status'] as String? ?? 'completed',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      );
    }).toList();
  }

  GameType _parseGameType(String? value) {
    return GameType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => GameType.single,
    );
  }

  void _ensureConfigured() {
    if (!FirebaseInitializer.isInitialized) {
      throw StateError('Firebase yapılandırılmamış.');
    }
  }
}
