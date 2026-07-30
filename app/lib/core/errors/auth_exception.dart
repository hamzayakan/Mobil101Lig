/// Kimlik doğrulama hatası.
class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Firebase yapılandırması eksik.
class FirebaseNotConfiguredException extends AuthException {
  FirebaseNotConfiguredException()
      : super(
          'Firebase yapılandırılmamış. '
          'Lütfen flutterfire configure komutunu çalıştırın.',
        );
}
