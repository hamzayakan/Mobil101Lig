import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/game_type.dart';
import '../../domain/entities/round_entity.dart';
import '../../domain/entities/team_entity.dart';

/// Yazboz ekranı aşamaları.
enum YazbozPhase {
  setup,
  teamSetup,
  playing,
}

/// Yazboz ekranı state'i.
class YazbozState {
  const YazbozState({
    this.phase = YazbozPhase.setup,
    this.playerCount = 4,
    this.playerNames = const ['', '', '', ''],
    this.gameType = GameType.single,
    this.draftTeams = const [],
    this.game,
    this.rounds = const [],
    this.result,
    this.errorMessage,
    this.teamsConfirmed = false,
  });

  final YazbozPhase phase;
  final int playerCount;
  final List<String> playerNames;
  final GameType gameType;

  /// Takım kurulumu aşamasında düzenlenen taslak takımlar.
  final List<TeamEntity> draftTeams;

  final GameEntity? game;
  final List<RoundEntity> rounds;
  final GameResult? result;
  final String? errorMessage;
  final bool teamsConfirmed;

  YazbozState copyWith({
    YazbozPhase? phase,
    int? playerCount,
    List<String>? playerNames,
    GameType? gameType,
    List<TeamEntity>? draftTeams,
    GameEntity? game,
    List<RoundEntity>? rounds,
    GameResult? result,
    String? errorMessage,
    bool? teamsConfirmed,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return YazbozState(
      phase: phase ?? this.phase,
      playerCount: playerCount ?? this.playerCount,
      playerNames: playerNames ?? this.playerNames,
      gameType: gameType ?? this.gameType,
      draftTeams: draftTeams ?? this.draftTeams,
      game: game ?? this.game,
      rounds: rounds ?? this.rounds,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      teamsConfirmed: teamsConfirmed ?? this.teamsConfirmed,
    );
  }
}
