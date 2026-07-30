import '../../../auth/data/datasources/firestore_user_datasource.dart';
import '../../../../core/errors/league_exception.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/entities/league_member_entity.dart';
import '../../domain/repositories/league_repository.dart';
import '../datasources/firestore_league_datasource.dart';

/// Firestore tabanlı lig repository implementasyonu.
class LeagueRepositoryImpl implements LeagueRepository {
  LeagueRepositoryImpl({
    required FirestoreLeagueDataSource dataSource,
    required FirestoreUserDataSource userDataSource,
  })  : _dataSource = dataSource,
        _userDataSource = userDataSource;

  final FirestoreLeagueDataSource _dataSource;
  final FirestoreUserDataSource _userDataSource;

  @override
  Future<LeagueEntity> createLeague({
    required String name,
    required String ownerId,
    required String ownerDisplayName,
  }) async {
    final league = await _dataSource.createLeague(
      name: name,
      ownerId: ownerId,
      ownerDisplayName: ownerDisplayName,
    );
    return league.toEntity();
  }

  @override
  Future<List<LeagueEntity>> getUserLeagues(String userId) async {
    final leagues = await _dataSource.getUserLeagues(userId);
    return leagues.map((league) => league.toEntity()).toList();
  }

  @override
  Future<List<LeagueMemberEntity>> getLeagueMembers(String leagueId) async {
    final members = await _dataSource.getLeagueMembers(leagueId);
    return members.map((member) => member.toEntity()).toList();
  }

  @override
  Future<LeagueEntity?> getLeague(String leagueId) async {
    final league = await _dataSource.getLeague(leagueId);
    return league?.toEntity();
  }

  @override
  Future<void> addMember({
    required String leagueId,
    required String userId,
    required String displayName,
  }) {
    return _dataSource.addMember(
      leagueId: leagueId,
      userId: userId,
      displayName: displayName,
    );
  }

  @override
  Future<void> addMemberByEmail({
    required String leagueId,
    required String email,
  }) async {
    final user = await _userDataSource.findUserByEmail(email);
    if (user == null) {
      throw LeagueException(
        'Bu e-posta ile kayıtlı kullanıcı bulunamadı. '
        'Kullanıcının en az bir kez giriş yapmış olması gerekir.',
      );
    }

    await addMember(
      leagueId: leagueId,
      userId: user.id,
      displayName: user.displayName,
    );
  }

  @override
  Future<void> applyGameScores({
    required String leagueId,
    required Map<String, int> scoresByUserId,
  }) {
    return _dataSource.applyGameScores(
      leagueId: leagueId,
      scoresByUserId: scoresByUserId,
    );
  }
}
