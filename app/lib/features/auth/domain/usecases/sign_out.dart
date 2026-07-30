import '../repositories/auth_repository.dart';

/// Oturum kapatma use case'i.
class SignOutUseCase {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  /// Aktif oturumu sonlandırır.
  Future<void> execute() => _repository.signOut();
}
