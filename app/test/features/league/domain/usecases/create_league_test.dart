import 'package:app/features/league/domain/entities/league_entity.dart';
import 'package:app/features/league/domain/entities/league_member_entity.dart';
import 'package:app/features/league/domain/repositories/league_repository.dart';
import 'package:app/features/league/domain/usecases/create_league.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLeagueRepository implements LeagueRepository {
  String? lastName;
  String? lastOwnerId;

  @override
  Future<LeagueEntity> createLeague({
    required String name,
    required String ownerId,
    required String ownerDisplayName,
  }) async {
    lastName = name;
    lastOwnerId = ownerId;
    return LeagueEntity(
      id: 'league1',
      name: name,
      ownerId: ownerId,
      maxPlayers: 20,
      status: 'active',
    );
  }

  @override
  Future<LeagueEntity?> getLeague(String leagueId) async => null;

  @override
  Future<List<LeagueMemberEntity>> getLeagueMembers(String leagueId) async =>
      [];

  @override
  Future<List<LeagueEntity>> getUserLeagues(String userId) async => [];

  @override
  Future<void> addMember({
    required String leagueId,
    required String userId,
    required String displayName,
  }) async {}

  @override
  Future<void> addMemberByEmail({
    required String leagueId,
    required String email,
  }) async {}

  @override
  Future<void> applyGameScores({
    required String leagueId,
    required Map<String, int> scoresByUserId,
  }) async {}
}

void main() {
  group('CreateLeagueUseCase', () {
    test('boş lig adında hata fırlatır', () async {
      final useCase = CreateLeagueUseCase(_FakeLeagueRepository());

      expect(
        () => useCase.execute(
          name: '   ',
          ownerId: 'uid1',
          ownerDisplayName: 'Test',
        ),
        throwsArgumentError,
      );
    });

    test('geçerli lig adını repository\'ye iletir', () async {
      final repository = _FakeLeagueRepository();
      final useCase = CreateLeagueUseCase(repository);

      final league = await useCase.execute(
        name: ' 101 Ligimiz ',
        ownerId: 'uid1',
        ownerDisplayName: 'Test User',
      );

      expect(repository.lastName, '101 Ligimiz');
      expect(repository.lastOwnerId, 'uid1');
      expect(league.name, '101 Ligimiz');
    });
  });
}
