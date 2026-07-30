import '../entities/user_entity.dart';

/// Kimlik doğrulama veri erişim arayüzü.
abstract class AuthRepository {
  /// Oturum durumu değişikliklerini dinler.
  Stream<UserEntity?> authStateChanges();

  /// Aktif kullanıcıyı döndürür.
  UserEntity? get currentUser;

  /// Google hesabı ile giriş yapar.
  Future<UserEntity> signInWithGoogle();

  /// Oturumu kapatır.
  Future<void> signOut();
}
