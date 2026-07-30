import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/game_type.dart';
import '../providers/yazboz_notifier.dart';

/// Skor özeti ve kazanan/kaybeden gösterimi.
class ScoreSummarySection extends ConsumerWidget {
  const ScoreSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(yazbozNotifierProvider);
    final game = state.game;
    final result = state.result;

    if (game == null || result == null) {
      return const SizedBox.shrink();
    }

    final winnerIds = result.winners.map((p) => p.id).toSet();
    final loserIds = result.losers.map((p) => p.id).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Toplam Skorlar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...game.players.map((player) {
              final total = result.totalScores[player.id] ?? 0;
              Color? chipColor;
              if (winnerIds.contains(player.id)) {
                chipColor = Colors.green.shade100;
              } else if (loserIds.contains(player.id)) {
                chipColor = Colors.red.shade100;
              }

              return ListTile(
                tileColor: chipColor,
                title: Text(player.name),
                trailing: Text(
                  total.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
            if (game.gameType == GameType.team &&
                result.teamScores.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Takım Skorları',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...result.teamScores.entries.map((entry) {
                final team = game.teams?.firstWhere(
                  (t) => t.id == entry.key,
                  orElse: () => game.teams!.first,
                );
                final isWinner = result.winningTeams.any(
                  (t) => t.id == entry.key,
                );
                final isLoser = result.losingTeams.any(
                  (t) => t.id == entry.key,
                );

                return ListTile(
                  tileColor: isWinner
                      ? Colors.green.shade100
                      : isLoser
                          ? Colors.red.shade100
                          : null,
                  title: Text(team?.name ?? entry.key),
                  trailing: Text(
                    entry.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ],
            if (result.winners.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  const Text('Kazanan:'),
                  ...result.winners.map(
                    (p) => Chip(
                      label: Text(p.name),
                      backgroundColor: Colors.green.shade200,
                    ),
                  ),
                ],
              ),
            ],
            if (result.losers.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  const Text('Kaybeden:'),
                  ...result.losers.map(
                    (p) => Chip(
                      label: Text(p.name),
                      backgroundColor: Colors.red.shade200,
                    ),
                  ),
                ],
              ),
            ],
            if (game.gameType == GameType.team &&
                result.winningTeams.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  const Text('Kazanan Takım:'),
                  ...result.winningTeams.map(
                    (t) => Chip(
                      label: Text(t.name),
                      backgroundColor: Colors.green.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
