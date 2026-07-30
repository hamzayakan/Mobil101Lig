import '../entities/league_entity.dart';
import '../repositories/league_repository.dart';

/// Tek lig bilgisini getirir.
class GetLeagueUseCase {
  GetLeagueUseCase(this._repository);

  final LeagueRepository _repository;

  Future<LeagueEntity?> execute(String leagueId) =>
      _repository.getLeague(leagueId);
}
