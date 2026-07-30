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

/// Aktif oturum durumunu dinler.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  if (!FirebaseInitializer.isInitialized) {
    return Stream.value(null);
  }
  return ref.watch(authRepositoryProvider).authStateChanges();
});
