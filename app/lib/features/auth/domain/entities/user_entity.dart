/// Oturum açmış kullanıcı domain nesnesi.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  /// Firebase Auth uid.
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
}
