import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../league/domain/entities/league_member_entity.dart';
import '../../../league/presentation/providers/league_providers.dart';
import '../../domain/entities/game_type.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/usecases/assign_teams.dart';
import 'game_providers.dart';
import 'yazboz_state.dart';

export 'yazboz_state.dart';

/// Yazboz ekranı state yöneticisi.
class YazbozNotifier extends Notifier<YazbozState> {
  @override
  YazbozState build() => const YazbozState();

  void setPlayerCount(int count) {
    final names = List<String>.generate(count, (i) {
      if (i < state.playerNames.length) {
        return state.playerNames[i];
      }
      return '';
    });
    state = state.copyWith(
      playerCount: count,
      playerNames: names,
      clearError: true,
    );
  }

  void setPlayerName(int index, String name) {
    final names = List<String>.from(state.playerNames);
    names[index] = name;
    state = state.copyWith(playerNames: names, clearError: true);
  }

  void setGameType(GameType type) {
    state = state.copyWith(gameType: type, clearError: true);
  }

  Future<void> setSelectedLeague(String? leagueId, String? leagueName) async {
    if (leagueId == null) {
      state = state.copyWith(clearLeague: true, clearError: true);
      return;
    }

    state = state.copyWith(
      selectedLeagueId: leagueId,
      selectedLeagueName: leagueName,
      clearError: true,
    );

    final members =
        await ref.read(getLeagueMembersUseCaseProvider).execute(leagueId);
    _applyLeagueMembers(members);
  }

  void _applyLeagueMembers(List<LeagueMemberEntity> members) {
    final count = state.playerCount;
    final names = List<String>.generate(count, (index) {
      if (index < members.length) {
        return members[index].displayName;
      }
      if (index < state.playerNames.length) {
        return state.playerNames[index];
      }
      return '';
    });

    state = state.copyWith(
      leagueMembers: members,
      playerNames: names,
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> startGame() async {
    final names = state.playerNames.map((n) => n.trim()).toList();

    if (names.any((n) => n.isEmpty)) {
      state = state.copyWith(errorMessage: 'Tüm oyuncu isimlerini girin.');
      return;
    }

    if (state.gameType == GameType.team && state.playerCount.isOdd) {
      state = state.copyWith(
        errorMessage: 'Eşli oyunda oyuncu sayısı çift olmalıdır.',
      );
      return;
    }

    final currentUser = ref.read(authStateProvider).valueOrNull;
    final players = List<PlayerEntity>.generate(
      state.playerCount,
      (i) => PlayerEntity(
        id: 'player_$i',
        name: names[i],
        userId: _userIdForPlayerName(names[i]),
      ),
    );

    final createGame = ref.read(createGameUseCaseProvider);
    final game = await createGame.execute(
      players: players,
      gameType: state.gameType,
      createdByUserId: currentUser?.id,
      leagueId: state.selectedLeagueId,
    );

    if (state.gameType == GameType.team) {
      final draftTeams = _buildDefaultTeams(players);
      state = state.copyWith(
        game: game,
        draftTeams: draftTeams,
        rounds: const [],
        phase: YazbozPhase.teamSetup,
        clearError: true,
        teamsConfirmed: false,
        clearResult: true,
        isSaved: false,
        clearSaveMessage: true,
      );
    } else {
      state = state.copyWith(
        game: game,
        rounds: const [],
        phase: YazbozPhase.playing,
        clearError: true,
        clearResult: true,
        isSaved: false,
        clearSaveMessage: true,
      );
      await _refreshResult();
    }
  }

  String? _userIdForPlayerName(String name) {
    final normalized = name.trim().toLowerCase();
    for (final member in state.leagueMembers) {
      if (member.displayName.trim().toLowerCase() == normalized) {
        return member.userId;
      }
    }
    return null;
  }

  List<TeamEntity> _buildDefaultTeams(List<PlayerEntity> players) {
    final half = players.length ~/ 2;
    return [
      TeamEntity(
        id: 'team_a',
        name: 'Takım A',
        playerIds: players.take(half).map((p) => p.id).toList(),
      ),
      TeamEntity(
        id: 'team_b',
        name: 'Takım B',
        playerIds: players.skip(half).map((p) => p.id).toList(),
      ),
    ];
  }

  void movePlayerToTeam(String playerId, String targetTeamId) {
    final teams = state.draftTeams.map((team) {
      final ids = team.playerIds.where((id) => id != playerId).toList();
      if (team.id == targetTeamId) {
        ids.add(playerId);
      }
      return team.copyWith(playerIds: ids);
    }).toList();

    state = state.copyWith(draftTeams: teams, clearError: true);
  }

  Future<void> confirmTeams() async {
    final game = state.game;
    if (game == null) {
      return;
    }

    try {
      final assignTeams = ref.read(assignTeamsUseCaseProvider);
      final updatedGame = await assignTeams.execute(
        game: game,
        teams: state.draftTeams,
      );

      state = state.copyWith(
        game: updatedGame,
        phase: YazbozPhase.playing,
        teamsConfirmed: true,
        clearError: true,
      );
      await _refreshResult();
    } on TeamAssignmentException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  Future<void> addRound(Map<String, int> playerScores) async {
    if (state.game == null) {
      return;
    }

    try {
      final addRound = ref.read(addRoundUseCaseProvider);
      await addRound.execute(playerScores);
      await _syncRounds();
      await _refreshResult();
      state = state.copyWith(
        clearError: true,
        isSaved: false,
        clearSaveMessage: true,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateRound({
    required int roundNumber,
    required Map<String, int> playerScores,
  }) async {
    if (state.game == null) {
      return;
    }

    try {
      final updateRound = ref.read(updateRoundUseCaseProvider);
      await updateRound.execute(
        roundNumber: roundNumber,
        playerScores: playerScores,
      );
      await _syncRounds();
      await _refreshResult();
      state = state.copyWith(
        clearError: true,
        isSaved: false,
        clearSaveMessage: true,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteRound(int roundNumber) async {
    if (state.game == null) {
      return;
    }

    try {
      final deleteRound = ref.read(deleteRoundUseCaseProvider);
      await deleteRound.execute(roundNumber);
      await _syncRounds();
      await _refreshResult();
      state = state.copyWith(
        clearError: true,
        isSaved: false,
        clearSaveMessage: true,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> saveGameToLeague() async {
    final game = state.game;
    final result = state.result;
    if (game == null || result == null) {
      return;
    }

    if (state.selectedLeagueId == null) {
      state = state.copyWith(
        errorMessage: 'Lig kaydı için kurulumda lig seçmelisiniz.',
      );
      return;
    }

    if (state.rounds.isEmpty) {
      state = state.copyWith(errorMessage: 'Kaydetmek için en az bir el girin.');
      return;
    }

    state = state.copyWith(isSaving: true, clearError: true, clearSaveMessage: true);

    try {
      var members = state.leagueMembers;
      if (members.isEmpty) {
        members = await ref
            .read(getLeagueMembersUseCaseProvider)
            .execute(state.selectedLeagueId!);
      }

      await ref.read(completeAndSaveGameUseCaseProvider).execute(
            game: game,
            rounds: state.rounds,
            result: result,
            leagueMembers: members,
          );

      state = state.copyWith(
        isSaving: false,
        isSaved: true,
        saveMessage: 'Oyun lige kaydedildi. Sıralama güncellendi.',
      );
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Oyun kaydedilemedi: $error',
      );
    }
  }

  Future<void> _syncRounds() async {
    final rounds = await ref.read(gameRepositoryProvider).getRounds();
    state = state.copyWith(rounds: rounds);
  }

  Future<void> _refreshResult() async {
    final getResult = ref.read(getGameResultUseCaseProvider);
    final result = await getResult.execute();
    state = state.copyWith(result: result);
  }

  void reset() {
    ref.read(gameRepositoryProvider).clear();
    state = const YazbozState();
  }
}

final yazbozNotifierProvider =
    NotifierProvider<YazbozNotifier, YazbozState>(YazbozNotifier.new);
