import '../../domain/repositories/league_repository.dart';

/// E-posta ile lig üyesi ekleme use case'i.
class AddLeagueMemberUseCase {
  AddLeagueMemberUseCase(this._repository);

  final LeagueRepository _repository;

  Future<void> execute({
    required String leagueId,
    required String email,
  }) {
    return _repository.addMemberByEmail(
      leagueId: leagueId,
      email: email,
    );
  }
}
