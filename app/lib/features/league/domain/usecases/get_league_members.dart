import '../entities/league_member_entity.dart';
import '../repositories/league_repository.dart';

/// Lig üyelerini getirir.
class GetLeagueMembersUseCase {
  GetLeagueMembersUseCase(this._repository);

  final LeagueRepository _repository;

  Future<List<LeagueMemberEntity>> execute(String leagueId) =>
      _repository.getLeagueMembers(leagueId);
}
