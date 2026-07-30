import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/firebase/firebase_initializer.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Firestore kullanıcı profili veri kaynağı.
class FirestoreUserDataSource {
  FirestoreUserDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _usersCollection = 'users';

  Future<void> upsertUser(UserEntity user) async {
    _ensureConfigured();

    await _firestore.collection(_usersCollection).doc(user.id).set(
      {
        'id': user.id,
        'email': user.email.toLowerCase(),
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<UserEntity?> findUserByEmail(String email) async {
    _ensureConfigured();

    final query = await _firestore
        .collection(_usersCollection)
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final data = query.docs.first.data();
    return UserEntity(
      id: data['id'] as String? ?? query.docs.first.id,
      email: data['email'] as String? ?? email,
      displayName: data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
    );
  }

  void _ensureConfigured() {
    if (!FirebaseInitializer.isInitialized) {
      throw StateError('Firebase yapılandırılmamış.');
    }
  }
}
