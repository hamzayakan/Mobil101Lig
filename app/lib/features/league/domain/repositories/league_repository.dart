import '../entities/league_entity.dart';
import '../entities/league_member_entity.dart';

/// Lig veri erişim arayüzü.
abstract class LeagueRepository {
  /// Yeni lig oluşturur; sahibi otomatik üye olur.
  Future<LeagueEntity> createLeague({
    required String name,
    required String ownerId,
    required String ownerDisplayName,
  });

  /// Kullanıcının üye olduğu ligleri döndürür.
  Future<List<LeagueEntity>> getUserLeagues(String userId);

  /// Lig üyelerini puan sırasına göre döndürür (101: düşük skor üstte).
  Future<List<LeagueMemberEntity>> getLeagueMembers(String leagueId);

  /// Tek lig bilgisini döndürür.
  Future<LeagueEntity?> getLeague(String leagueId);

  /// E-posta ile kullanıcıyı lige ekler.
  Future<void> addMemberByEmail({
    required String leagueId,
    required String email,
  });

  /// Lig üyesi ekler.
  Future<void> addMember({
    required String leagueId,
    required String userId,
    required String displayName,
  });

  /// Oyun sonuçlarını lig üyelerine uygular.
  Future<void> applyGameScores({
    required String leagueId,
    required Map<String, int> scoresByUserId,
  });
}
