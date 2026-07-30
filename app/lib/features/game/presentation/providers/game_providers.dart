import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_game_datasource.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/services/default_score_calculator.dart';
import '../../domain/services/score_calculator.dart';
import '../../data/datasources/firestore_game_datasource.dart';
import '../../domain/entities/saved_game_summary.dart';
import '../../data/repositories/game_persistence_repository_impl.dart';
import '../../domain/repositories/game_persistence_repository.dart';
import '../../domain/usecases/add_round.dart';
import '../../domain/usecases/assign_teams.dart';
import '../../domain/usecases/complete_and_save_game.dart';
import '../../domain/usecases/create_game.dart';
import '../../domain/usecases/delete_round.dart';
import '../../domain/usecases/determine_winner.dart';
import '../../domain/usecases/get_game_result.dart';
import '../../domain/usecases/update_round.dart';

import '../../../league/presentation/providers/league_providers.dart';

final firestoreGameDataSourceProvider = Provider<FirestoreGameDataSource>(
  (_) => FirestoreGameDataSource(),
);

final gamePersistenceRepositoryProvider = Provider<GamePersistenceRepository>(
  (ref) {
    return GamePersistenceRepositoryImpl(
      gameDataSource: ref.watch(firestoreGameDataSourceProvider),
      leagueRepository: ref.watch(leagueRepositoryProvider),
    );
  },
);

final localGameDataSourceProvider = Provider<LocalGameDataSource>(
  (_) => LocalGameDataSource(),
);

final scoreCalculatorProvider = Provider<ScoreCalculator>(
  (_) => DefaultScoreCalculator(),
);

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepositoryImpl(ref.watch(localGameDataSourceProvider));
});

final createGameUseCaseProvider = Provider(
  (ref) => CreateGameUseCase(ref.watch(gameRepositoryProvider)),
);

final assignTeamsUseCaseProvider = Provider(
  (ref) => AssignTeamsUseCase(ref.watch(gameRepositoryProvider)),
);

final addRoundUseCaseProvider = Provider(
  (ref) => AddRoundUseCase(ref.watch(gameRepositoryProvider)),
);

final updateRoundUseCaseProvider = Provider(
  (ref) => UpdateRoundUseCase(ref.watch(gameRepositoryProvider)),
);

final deleteRoundUseCaseProvider = Provider(
  (ref) => DeleteRoundUseCase(ref.watch(gameRepositoryProvider)),
);

final determineWinnerUseCaseProvider = Provider(
  (ref) => DetermineWinnerUseCase(ref.watch(scoreCalculatorProvider)),
);

final getGameResultUseCaseProvider = Provider(
  (ref) => GetGameResultUseCase(
    ref.watch(gameRepositoryProvider),
    ref.watch(determineWinnerUseCaseProvider),
  ),
);

final completeAndSaveGameUseCaseProvider = Provider(
  (ref) => CompleteAndSaveGameUseCase(
    ref.watch(gamePersistenceRepositoryProvider),
  ),
);

/// Lig oyun geçmişi.
final leagueGamesProvider =
    FutureProvider.family<List<SavedGameSummary>, String>(
  (ref, leagueId) =>
      ref.watch(gamePersistenceRepositoryProvider).getLeagueGames(leagueId),
);
