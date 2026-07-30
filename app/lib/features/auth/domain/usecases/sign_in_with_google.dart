import '../repositories/auth_repository.dart';

/// Google ile giriş use case'i.
class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  /// Google hesabı ile oturum açar.
  Future<void> execute() => _repository.signInWithGoogle();
}
