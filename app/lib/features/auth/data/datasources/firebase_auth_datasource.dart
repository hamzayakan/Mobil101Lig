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
    return Stream.multi((controller) {
      controller.add(_mapUser(_firebaseAuth.currentUser));
      final subscription = _firebaseAuth.authStateChanges().listen(
        (user) => controller.add(_mapUser(user)),
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = subscription.cancel;
    });
  }

  UserEntity? get currentUser => _mapUser(_firebaseAuth.currentUser);

  /// Web (Chrome) için Google redirect ile giriş başlatır.
  ///
  /// Sayfa Google'a yönlendirilir; dönüşte [completeWebRedirectSignIn] çağrılmalıdır.
  Future<void> startWebGoogleSignIn() async {
    _ensureConfigured();
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});
    await _firebaseAuth.signInWithRedirect(provider);
  }

  /// Redirect sonrası oturum sonucunu tamamlar.
  Future<UserEntity?> completeWebRedirectSignIn() async {
    _ensureConfigured();
    final result = await _firebaseAuth.getRedirectResult();
    return _mapUser(result.user);
  }

  /// Web (Chrome) için Firebase Google popup girişi.
  Future<UserEntity> signInWithGooglePopup() async {
    _ensureConfigured();
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});

    try {
      final result = await _firebaseAuth.signInWithPopup(provider);
      final user = _mapUser(result.user);
      if (user == null) {
        throw AuthException('Google girişi tamamlanamadı.');
      }
      return user;
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthError(error);
    }
  }

  /// Google credential ile Firebase oturumu açar.
  Future<UserEntity> signInWithCredential(AuthCredential credential) async {
    _ensureConfigured();
    try {
      final result = await _firebaseAuth.signInWithCredential(credential);
      final user = _mapUser(result.user);
      if (user == null) {
        throw AuthException('Google girişi tamamlanamadı.');
      }
      return user;
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthError(error);
    }
  }

  Future<void> signOut() async {
    _ensureConfigured();
    await _firebaseAuth.signOut();
  }

  AuthException _mapFirebaseAuthError(FirebaseAuthException error) {
    if (error.code == 'permission-denied' ||
        (error.message?.contains('PERMISSION_DENIED') ?? false)) {
      return AuthException(
        'Firebase Web yapılandırması eksik. Firebase Console\'da '
        'Web uygulaması (</>) ekleyin ve firebase_options.dart içindeki '
        'web appId değerini güncelleyin.',
      );
    }

    return AuthException(
      'Google girişi başarısız: ${error.code} — ${error.message ?? ''}',
    );
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
