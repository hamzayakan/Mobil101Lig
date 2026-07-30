import '../entities/game_result.dart';
import '../entities/game_type.dart';
import '../entities/player_entity.dart';
import '../entities/round_entity.dart';
import '../entities/team_entity.dart';
import 'score_calculator.dart';

/// Varsayılan skor hesaplama servisi (el skorlarını toplar).
class DefaultScoreCalculator implements ScoreCalculator {
  @override
  Map<String, int> calculateTotals(
    List<RoundEntity> rounds,
    List<String> playerIds,
  ) {
    final totals = {for (final id in playerIds) id: 0};

    for (final round in rounds) {
      for (final playerId in playerIds) {
        totals[playerId] =
            (totals[playerId] ?? 0) + (round.playerScores[playerId] ?? 0);
      }
    }

    return totals;
  }

  @override
  GameResult determineResult({
    required Map<String, int> totalScores,
    required GameType gameType,
    required List<PlayerEntity> players,
    required List<TeamEntity>? teams,
  }) {
    if (gameType == GameType.team && teams != null && teams.isNotEmpty) {
      return _determineTeamResult(
        totalScores: totalScores,
        players: players,
        teams: teams,
      );
    }

    return _determineSingleResult(
      totalScores: totalScores,
      players: players,
    );
  }

  GameResult _determineSingleResult({
    required Map<String, int> totalScores,
    required List<PlayerEntity> players,
  }) {
    if (totalScores.isEmpty) {
      return GameResult(
        totalScores: totalScores,
        winners: const [],
        losers: const [],
      );
    }

    final minScore = totalScores.values.reduce((a, b) => a < b ? a : b);
    final maxScore = totalScores.values.reduce((a, b) => a > b ? a : b);

    final winners = players
        .where((p) => totalScores[p.id] == minScore)
        .toList();
    final losers = players
        .where((p) => totalScores[p.id] == maxScore)
        .toList();

    return GameResult(
      totalScores: totalScores,
      winners: winners,
      losers: losers,
    );
  }

  GameResult _determineTeamResult({
    required Map<String, int> totalScores,
    required List<PlayerEntity> players,
    required List<TeamEntity> teams,
  }) {
    final teamScores = <String, int>{};
    for (final team in teams) {
      var sum = 0;
      for (final playerId in team.playerIds) {
        sum += totalScores[playerId] ?? 0;
      }
      teamScores[team.id] = sum;
    }

    if (teamScores.isEmpty) {
      return GameResult(
        totalScores: totalScores,
        winners: const [],
        losers: const [],
        teamScores: teamScores,
      );
    }

    final minTeamScore =
        teamScores.values.reduce((a, b) => a < b ? a : b);
    final maxTeamScore =
        teamScores.values.reduce((a, b) => a > b ? a : b);

    final winningTeams =
        teams.where((t) => teamScores[t.id] == minTeamScore).toList();
    final losingTeams =
        teams.where((t) => teamScores[t.id] == maxTeamScore).toList();

    final winnerIds = winningTeams.expand((t) => t.playerIds).toSet();
    final loserIds = losingTeams.expand((t) => t.playerIds).toSet();

    final winners = players.where((p) => winnerIds.contains(p.id)).toList();
    final losers = players.where((p) => loserIds.contains(p.id)).toList();

    return GameResult(
      totalScores: totalScores,
      winners: winners,
      losers: losers,
      teamScores: teamScores,
      winningTeams: winningTeams,
      losingTeams: losingTeams,
    );
  }
}
