import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firebase/firebase_initializer.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>(
  (_) => FirebaseAuthDataSource(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authDataSource: ref.watch(firebaseAuthDataSourceProvider),
  );
});

final signInWithGoogleUseCaseProvider = Provider(
  (ref) => SignInWithGoogleUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

/// Web redirect dönüşünü tamamlar (varsa).
final webAuthBootstrapProvider = FutureProvider<void>((ref) async {
  if (!kIsWeb || !FirebaseInitializer.isInitialized) {
    return;
  }
  await ref.read(firebaseAuthDataSourceProvider).completeWebRedirectSignIn();
});

/// Aktif oturum durumunu dinler.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final bootstrap = ref.watch(webAuthBootstrapProvider);

  return bootstrap.when(
    loading: () => Stream.value(null),
    error: (error, stackTrace) => Stream.error(error, stackTrace),
    data: (_) {
      if (!FirebaseInitializer.isInitialized) {
        return Stream.value(null);
      }
      return ref.watch(authRepositoryProvider).authStateChanges();
    },
  );
});
