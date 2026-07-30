import 'game_type.dart';
import 'player_entity.dart';
import 'team_entity.dart';

/// Oyun domain nesnesi.
class GameEntity {
  const GameEntity({
    required this.id,
    required this.players,
    required this.gameType,
    this.teams,
    this.createdByUserId,
    this.leagueId,
  });

  final String id;
  final List<PlayerEntity> players;
  final GameType gameType;
  final List<TeamEntity>? teams;
  final String? createdByUserId;
  final String? leagueId;

  GameEntity copyWith({
    String? id,
    List<PlayerEntity>? players,
    GameType? gameType,
    List<TeamEntity>? teams,
    String? createdByUserId,
    String? leagueId,
  }) {
    return GameEntity(
      id: id ?? this.id,
      players: players ?? this.players,
      gameType: gameType ?? this.gameType,
      teams: teams ?? this.teams,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      leagueId: leagueId ?? this.leagueId,
    );
  }
}
