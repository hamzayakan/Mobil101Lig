import '../../../league/domain/entities/league_member_entity.dart';
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
    this.selectedLeagueId,
    this.selectedLeagueName,
    this.leagueMembers = const [],
    this.isSaving = false,
    this.isSaved = false,
    this.saveMessage,
  });

  final YazbozPhase phase;
  final int playerCount;
  final List<String> playerNames;
  final GameType gameType;
  final List<TeamEntity> draftTeams;
  final GameEntity? game;
  final List<RoundEntity> rounds;
  final GameResult? result;
  final String? errorMessage;
  final bool teamsConfirmed;
  final String? selectedLeagueId;
  final String? selectedLeagueName;
  final List<LeagueMemberEntity> leagueMembers;
  final bool isSaving;
  final bool isSaved;
  final String? saveMessage;

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
    String? selectedLeagueId,
    String? selectedLeagueName,
    List<LeagueMemberEntity>? leagueMembers,
    bool? isSaving,
    bool? isSaved,
    String? saveMessage,
    bool clearError = false,
    bool clearResult = false,
    bool clearLeague = false,
    bool clearSaveMessage = false,
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
      selectedLeagueId:
          clearLeague ? null : (selectedLeagueId ?? this.selectedLeagueId),
      selectedLeagueName:
          clearLeague ? null : (selectedLeagueName ?? this.selectedLeagueName),
      leagueMembers: clearLeague
          ? const []
          : (leagueMembers ?? this.leagueMembers),
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      saveMessage: clearSaveMessage ? null : (saveMessage ?? this.saveMessage),
    );
  }
}
