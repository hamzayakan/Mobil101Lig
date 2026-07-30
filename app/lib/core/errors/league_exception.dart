/// Lig işlemi hatası.
class LeagueException implements Exception {
  LeagueException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Oturum açmadan lig işlemi yapılamaz.
class LeagueAuthRequiredException extends LeagueException {
  LeagueAuthRequiredException()
      : super('Lig işlemleri için giriş yapmanız gerekir.');
}

/// Firestore yapılandırılmamış.
class FirestoreNotConfiguredException extends LeagueException {
  FirestoreNotConfiguredException()
      : super(
          'Firestore yapılandırılmamış. '
          'Firebase Console\'da Firestore Database\'i etkinleştirin.',
        );
}
