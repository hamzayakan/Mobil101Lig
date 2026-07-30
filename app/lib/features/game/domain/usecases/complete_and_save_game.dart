import '../../../league/domain/entities/league_member_entity.dart';
import '../entities/game_entity.dart';
import '../entities/game_result.dart';
import '../entities/round_entity.dart';
import '../repositories/game_persistence_repository.dart';

/// Oyunu Firestore'a kaydeder ve varsa lig puanlarını günceller.
class CompleteAndSaveGameUseCase {
  CompleteAndSaveGameUseCase(this._persistenceRepository);

  final GamePersistenceRepository _persistenceRepository;

  Future<String> execute({
    required GameEntity game,
    required List<RoundEntity> rounds,
    required GameResult result,
    required List<LeagueMemberEntity> leagueMembers,
  }) async {
    if (rounds.isEmpty) {
      throw ArgumentError('Kaydetmek için en az bir el gerekli.');
    }

    return _persistenceRepository.saveCompletedGame(
      game: game,
      rounds: rounds,
      result: result,
      leagueMembers: leagueMembers,
    );
  }
}
