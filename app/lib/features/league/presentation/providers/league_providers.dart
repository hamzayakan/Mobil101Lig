import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/datasources/firestore_user_datasource.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/firestore_league_datasource.dart';
import '../../data/repositories/league_repository_impl.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/entities/league_member_entity.dart';
import '../../domain/repositories/league_repository.dart';
import '../../domain/usecases/add_league_member.dart';
import '../../domain/usecases/create_league.dart';
import '../../domain/usecases/get_league.dart';
import '../../domain/usecases/get_league_members.dart';
import '../../domain/usecases/get_user_leagues.dart';

final firestoreUserDataSourceProvider = Provider<FirestoreUserDataSource>(
  (_) => FirestoreUserDataSource(),
);

final firestoreLeagueDataSourceProvider = Provider<FirestoreLeagueDataSource>(
  (_) => FirestoreLeagueDataSource(),
);

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepositoryImpl(
    dataSource: ref.watch(firestoreLeagueDataSourceProvider),
    userDataSource: ref.watch(firestoreUserDataSourceProvider),
  );
});

final createLeagueUseCaseProvider = Provider(
  (ref) => CreateLeagueUseCase(ref.watch(leagueRepositoryProvider)),
);

final getUserLeaguesUseCaseProvider = Provider(
  (ref) => GetUserLeaguesUseCase(ref.watch(leagueRepositoryProvider)),
);

final getLeagueMembersUseCaseProvider = Provider(
  (ref) => GetLeagueMembersUseCase(ref.watch(leagueRepositoryProvider)),
);

final getLeagueUseCaseProvider = Provider(
  (ref) => GetLeagueUseCase(ref.watch(leagueRepositoryProvider)),
);

final addLeagueMemberUseCaseProvider = Provider(
  (ref) => AddLeagueMemberUseCase(ref.watch(leagueRepositoryProvider)),
);

/// Giriş yapan kullanıcı profilini Firestore'a yazar.
final userProfileSyncProvider = Provider<void>((ref) {
  ref.listen(authStateProvider, (_, next) {
    final user = next.valueOrNull;
    if (user != null) {
      ref.read(firestoreUserDataSourceProvider).upsertUser(user);
    }
  });
});

/// Kullanıcının liglerini getirir.
final userLeaguesProvider = FutureProvider.family<List<LeagueEntity>, String>(
  (ref, userId) => ref.watch(getUserLeaguesUseCaseProvider).execute(userId),
);

/// Lig detayını getirir.
final leagueProvider = FutureProvider.family<LeagueEntity?, String>(
  (ref, leagueId) => ref.watch(getLeagueUseCaseProvider).execute(leagueId),
);

/// Lig üyelerini getirir.
final leagueMembersProvider =
    FutureProvider.family<List<LeagueMemberEntity>, String>(
  (ref, leagueId) =>
      ref.watch(getLeagueMembersUseCaseProvider).execute(leagueId),
);
