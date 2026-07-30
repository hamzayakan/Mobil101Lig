import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/auth_exception.dart';
import 'auth_providers.dart';
import 'login_state.dart';

export 'login_state.dart';

/// Giriş ekranı state yöneticisi.
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  /// Google hesabı ile giriş yapar.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: LoginStatus.loading, clearError: true);

    try {
      await ref.read(signInWithGoogleUseCaseProvider).execute();
      state = state.copyWith(status: LoginStatus.success);
      return true;
    } on AuthException catch (error) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error.message,
      );
      return false;
    } catch (error) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Beklenmeyen hata: $error',
      );
      return false;
    }
  }

  void reset() {
    state = const LoginState();
  }
}

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
