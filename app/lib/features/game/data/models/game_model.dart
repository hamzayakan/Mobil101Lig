import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_type.dart';
import 'player_model.dart';
import 'team_model.dart';

/// Oyun veri modeli.
class GameModel {
  const GameModel({
    required this.id,
    required this.players,
    required this.gameType,
    this.teams,
    this.createdByUserId,
    this.leagueId,
  });

  final String id;
  final List<PlayerModel> players;
  final GameType gameType;
  final List<TeamModel>? teams;
  final String? createdByUserId;
  final String? leagueId;

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] as String,
      players: (json['players'] as List)
          .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameType: GameType.values.byName(json['gameType'] as String),
      teams: json['teams'] != null
          ? (json['teams'] as List)
              .map((e) => TeamModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdByUserId: json['createdByUserId'] as String?,
      leagueId: json['leagueId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'players': players.map((p) => p.toJson()).toList(),
      'gameType': gameType.name,
      'teams': teams?.map((t) => t.toJson()).toList(),
      'createdByUserId': createdByUserId,
      'leagueId': leagueId,
    };
  }

  GameEntity toEntity() {
    return GameEntity(
      id: id,
      players: players.map((p) => p.toEntity()).toList(),
      gameType: gameType,
      teams: teams?.map((t) => t.toEntity()).toList(),
      createdByUserId: createdByUserId,
      leagueId: leagueId,
    );
  }

  factory GameModel.fromEntity(GameEntity entity) {
    return GameModel(
      id: entity.id,
      players: entity.players.map(PlayerModel.fromEntity).toList(),
      gameType: entity.gameType,
      teams: entity.teams?.map(TeamModel.fromEntity).toList(),
      createdByUserId: entity.createdByUserId,
      leagueId: entity.leagueId,
    );
  }

  GameModel copyWith({
    String? id,
    List<PlayerModel>? players,
    GameType? gameType,
    List<TeamModel>? teams,
    String? createdByUserId,
    String? leagueId,
  }) {
    return GameModel(
      id: id ?? this.id,
      players: players ?? this.players,
      gameType: gameType ?? this.gameType,
      teams: teams ?? this.teams,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      leagueId: leagueId ?? this.leagueId,
    );
  }
}
