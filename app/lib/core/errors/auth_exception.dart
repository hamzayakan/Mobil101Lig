/// Kimlik doğrulama hatası.
class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Web redirect girişi başlatıldı; sayfa Google'a yönlendiriliyor.
class WebAuthRedirectException extends AuthException {
  WebAuthRedirectException()
      : super('Google hesap seçimine yönlendiriliyorsunuz...');
}

/// Firebase yapılandırması eksik.
class FirebaseNotConfiguredException extends AuthException {
  FirebaseNotConfiguredException()
      : super(
          'Firebase yapılandırılmamış. '
          'Lütfen flutterfire configure komutunu çalıştırın.',
        );
}
