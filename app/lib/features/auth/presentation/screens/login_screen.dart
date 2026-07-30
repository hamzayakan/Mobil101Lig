import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_providers.dart';
import '../providers/login_notifier.dart';
import '../widgets/google_sign_in_button.dart';

/// Google ile giriş ekranı.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginNotifierProvider.notifier).reset();
    });
  }

  Future<void> _handleGoogleSignIn() async {
    final success =
        await ref.read(loginNotifierProvider.notifier).signInWithGoogle();
    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
      final user = next.valueOrNull;
      if (user != null && mounted) {
        context.pop();
      }
    });

    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.status == LoginStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.account_circle_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Mobil101Lig\'e Hoş Geldiniz',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Oyun geçmişinizi kaydetmek ve liglere katılmak için '
                'Google hesabınızla giriş yapın.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (loginState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        loginState.errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ),
                ),
              GoogleSignInButton(
                onPressed: isLoading ? null : _handleGoogleSignIn,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
