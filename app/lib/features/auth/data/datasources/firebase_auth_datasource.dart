import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/auth_exception.dart';
import '../../../../services/firebase/firebase_initializer.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Firebase Authentication veri kaynağı.
class FirebaseAuthDataSource {
  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Stream<UserEntity?> authStateChanges() {
    _ensureConfigured();
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  UserEntity? get currentUser => _mapUser(_firebaseAuth.currentUser);

  /// Google credential ile Firebase oturumu açar.
  Future<UserEntity> signInWithCredential(AuthCredential credential) async {
    _ensureConfigured();
    final result = await _firebaseAuth.signInWithCredential(credential);
    final user = _mapUser(result.user);
    if (user == null) {
      throw AuthException('Google girişi tamamlanamadı.');
    }
    return user;
  }

  Future<void> signOut() async {
    _ensureConfigured();
    await _firebaseAuth.signOut();
  }

  UserEntity? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel.fromFirebaseUser(user).toEntity();
  }

  void _ensureConfigured() {
    if (!FirebaseInitializer.isInitialized) {
      throw FirebaseNotConfiguredException();
    }
  }
}
