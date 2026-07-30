import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/yazboz_notifier.dart';

/// Manuel takım kurulum bölümü.
class TeamSetupSection extends ConsumerWidget {
  const TeamSetupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(yazbozNotifierProvider);
    final notifier = ref.read(yazbozNotifierProvider.notifier);
    final game = state.game;

    if (game == null || state.draftTeams.length < 2) {
      return const SizedBox.shrink();
    }

    final playerMap = {for (final p in game.players) p.id: p.name};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Takım Kurulumu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Her oyuncuyu doğru takıma atayın. Taşımak için oyuncuya dokunun.',
            ),
            const SizedBox(height: 12),
            ...state.draftTeams.map((team) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: team.playerIds.map((playerId) {
                        return InputChip(
                          label: Text(playerMap[playerId] ?? playerId),
                          onDeleted: state.draftTeams.length > 1
                              ? () {
                                  final otherTeam = state.draftTeams
                                      .firstWhere((t) => t.id != team.id);
                                  notifier.movePlayerToTeam(
                                    playerId,
                                    otherTeam.id,
                                  );
                                }
                              : null,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            ...game.players.map((player) {
              final currentTeam = state.draftTeams.firstWhere(
                (t) => t.playerIds.contains(player.id),
                orElse: () => state.draftTeams.first,
              );
              final otherTeam = state.draftTeams.firstWhere(
                (t) => t.id != currentTeam.id,
              );

              return ListTile(
                title: Text(player.name),
                subtitle: Text('Takım: ${currentTeam.name}'),
                trailing: TextButton(
                  onPressed: () => notifier.movePlayerToTeam(
                    player.id,
                    otherTeam.id,
                  ),
                  child: Text('${otherTeam.name}\'ya Taşı'),
                ),
              );
            }),
            FilledButton(
              onPressed: () => notifier.confirmTeams(),
              child: const Text('Takımları Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}
