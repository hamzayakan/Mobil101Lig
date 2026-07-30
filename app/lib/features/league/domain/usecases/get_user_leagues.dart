import '../entities/league_entity.dart';
import '../repositories/league_repository.dart';

/// Kullanıcı liglerini getirir.
class GetUserLeaguesUseCase {
  GetUserLeaguesUseCase(this._repository);

  final LeagueRepository _repository;

  Future<List<LeagueEntity>> execute(String userId) =>
      _repository.getUserLeagues(userId);
}
