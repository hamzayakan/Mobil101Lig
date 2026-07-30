import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../league/domain/entities/league_entity.dart';
import '../../../league/presentation/providers/league_providers.dart';
import '../../domain/entities/game_type.dart';
import '../providers/yazboz_notifier.dart';

/// Oyuncu kurulum bölümü.
class PlayerSetupSection extends ConsumerStatefulWidget {
  const PlayerSetupSection({super.key});

  @override
  ConsumerState<PlayerSetupSection> createState() =>
      _PlayerSetupSectionState();
}

class _PlayerSetupSectionState extends ConsumerState<PlayerSetupSection> {
  final _nameControllers = <TextEditingController>[];

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(int count, List<String> names) {
    while (_nameControllers.length < count) {
      final index = _nameControllers.length;
      _nameControllers.add(
        TextEditingController(text: index < names.length ? names[index] : ''),
      );
    }
    while (_nameControllers.length > count) {
      _nameControllers.removeLast().dispose();
    }
    for (var i = 0; i < count; i++) {
      if (_nameControllers[i].text != names[i]) {
        _nameControllers[i].text = names[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(yazbozNotifierProvider);
    final notifier = ref.read(yazbozNotifierProvider.notifier);
    final user = ref.watch(authStateProvider).valueOrNull;
    _syncControllers(state.playerCount, state.playerNames);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Oyun Kurulumu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (user != null) _LeagueSelector(userId: user.id),
            if (user != null) const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: state.playerCount,
              decoration: const InputDecoration(
                labelText: 'Oyuncu Sayısı',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 4, child: Text('4')),
              ],
              onChanged: (value) {
                if (value != null) {
                  notifier.setPlayerCount(value);
                }
              },
            ),
            const SizedBox(height: 12),
            SegmentedButton<GameType>(
              segments: const [
                ButtonSegment(
                  value: GameType.single,
                  label: Text('Tekli'),
                ),
                ButtonSegment(
                  value: GameType.team,
                  label: Text('Eşli'),
                ),
              ],
              selected: {state.gameType},
              onSelectionChanged: (selection) {
                notifier.setGameType(selection.first);
              },
            ),
            const SizedBox(height: 12),
            ...List.generate(state.playerCount, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  controller: _nameControllers[index],
                  textInputAction: index == state.playerCount - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Oyuncu ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => notifier.setPlayerName(index, value),
                ),
              );
            }),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                notifier.startGame();
              },
              child: const Text('Oyunu Başlat'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeagueSelector extends ConsumerWidget {
  const _LeagueSelector({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(yazbozNotifierProvider);
    final notifier = ref.read(yazbozNotifierProvider.notifier);
    final leaguesAsync = ref.watch(userLeaguesProvider(userId));

    return leaguesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text('Ligler yüklenemedi: $error'),
      data: (leagues) {
        return DropdownButtonFormField<String?>(
          initialValue: state.selectedLeagueId,
          decoration: const InputDecoration(
            labelText: 'Lig (opsiyonel)',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Lig seçme'),
            ),
            ...leagues.map(
              (LeagueEntity league) => DropdownMenuItem<String?>(
                value: league.id,
                child: Text(league.name),
              ),
            ),
          ],
          onChanged: (leagueId) async {
            if (leagueId == null) {
              await notifier.setSelectedLeague(null, null);
              return;
            }
            final league = leagues.firstWhere((item) => item.id == leagueId);
            await notifier.setSelectedLeague(league.id, league.name);
          },
        );
      },
    );
  }
}
