import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/auth_exception.dart';
import '../../../../firebase_options.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

/// Firebase tabanlı auth repository implementasyonu.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.authDataSource,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? _createGoogleSignIn();

  static GoogleSignIn _createGoogleSignIn() {
    if (kIsWeb) {
      return GoogleSignIn(
        clientId: DefaultFirebaseOptions.googleWebClientId,
      );
    }
    return GoogleSignIn(
      serverClientId: DefaultFirebaseOptions.googleWebClientId,
    );
  }

  final FirebaseAuthDataSource authDataSource;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<UserEntity?> authStateChanges() => authDataSource.authStateChanges();

  @override
  UserEntity? get currentUser => authDataSource.currentUser;

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return authDataSource.signInWithGooglePopup();
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google girişi iptal edildi.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return authDataSource.signInWithCredential(credential);
    } on AuthException {
      rethrow;
    } catch (error) {
      throw AuthException('Google girişi başarısız: $error');
    }
  }

  @override
  Future<void> signOut() async {
    await authDataSource.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }
}
