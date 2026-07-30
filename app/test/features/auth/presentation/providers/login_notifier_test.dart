import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/presentation/providers/auth_providers.dart';
import 'package:app/features/auth/presentation/providers/login_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository();

  UserEntity? user;
  var signInCalled = false;
  var signOutCalled = false;

  @override
  Stream<UserEntity?> authStateChanges() => Stream.value(user);

  @override
  UserEntity? get currentUser => user;

  @override
  Future<UserEntity> signInWithGoogle() async {
    signInCalled = true;
    user = const UserEntity(
      id: 'uid1',
      email: 'test@example.com',
      displayName: 'Test User',
    );
    return user!;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    user = null;
  }
}

void main() {
  group('LoginNotifier', () {
    test('Google giriş başarılı olunca success durumuna geçer', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(loginNotifierProvider.notifier);
      final success = await notifier.signInWithGoogle();

      expect(success, isTrue);
      expect(
        container.read(loginNotifierProvider).status,
        LoginStatus.success,
      );
    });
  });
}
