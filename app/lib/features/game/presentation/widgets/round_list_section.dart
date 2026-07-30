import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/round_entity.dart';
import '../providers/yazboz_notifier.dart';

/// El listesi ve skor giriş bölümü.
class RoundListSection extends ConsumerStatefulWidget {
  const RoundListSection({super.key});

  @override
  ConsumerState<RoundListSection> createState() => _RoundListSectionState();
}

class _RoundListSectionState extends ConsumerState<RoundListSection> {
  final _scoreControllers = <String, TextEditingController>{};
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (final controller in _scoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String playerId) {
    return _scoreControllers.putIfAbsent(playerId, TextEditingController.new);
  }

  Map<String, int>? _parseScores() {
    final state = ref.read(yazbozNotifierProvider);
    final game = state.game;
    if (game == null) {
      return null;
    }

    final scores = <String, int>{};
    for (final player in game.players) {
      final text = _controllerFor(player.id).text.trim();
      if (text.isEmpty) {
        _showMessage('${player.name} için skor girin.');
        return null;
      }
      final score = int.tryParse(text);
      if (score == null) {
        _showMessage('${player.name} için geçerli sayı girin.');
        return null;
      }
      scores[player.id] = score;
    }
    return scores;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitRound() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final scores = _parseScores();
    if (scores == null) {
      return;
    }

    FocusScope.of(context).unfocus();
    await ref.read(yazbozNotifierProvider.notifier).addRound(scores);

    for (final controller in _scoreControllers.values) {
      controller.clear();
    }
  }

  Future<void> _confirmDelete(RoundEntity round) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('El ${round.roundNumber} Silinsin mi?'),
        content: const Text('Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(yazbozNotifierProvider.notifier)
          .deleteRound(round.roundNumber);
    }
  }

  Future<void> _showEditSheet(RoundEntity round) async {
    final state = ref.read(yazbozNotifierProvider);
    final game = state.game;
    if (game == null) {
      return;
    }

    final editControllers = <String, TextEditingController>{};
    for (final player in game.players) {
      editControllers[player.id] = TextEditingController(
        text: '${round.playerScores[player.id] ?? 0}',
      );
    }

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'El ${round.roundNumber} Düzenle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...game.players.map((player) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: editControllers[player.id],
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: '${player.name} Skoru',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }),
              FilledButton(
                onPressed: () async {
                  final scores = <String, int>{};
                  for (final player in game.players) {
                    final text =
                        editControllers[player.id]!.text.trim();
                    final score = int.tryParse(text);
                    if (score == null) {
                      _showMessage('${player.name} için geçerli sayı girin.');
                      return;
                    }
                    scores[player.id] = score;
                  }

                  Navigator.pop(context);
                  await ref.read(yazbozNotifierProvider.notifier).updateRound(
                        roundNumber: round.roundNumber,
                        playerScores: scores,
                      );
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        );
      },
    );

    for (final controller in editControllers.values) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(yazbozNotifierProvider);
    final game = state.game;

    if (game == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'El Ekle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...game.players.map((player) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerFor(player.id),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: '${player.name} Skoru',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Skor girin';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Geçerli sayı girin';
                      }
                      return null;
                    },
                  ),
                );
              }),
              FilledButton.icon(
                onPressed: _submitRound,
                icon: const Icon(Icons.add),
                label: Text('El ${state.rounds.length + 1} Ekle'),
              ),
              if (state.rounds.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Oynanan Eller',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...state.rounds.map((round) {
                  final entries = game.players.map((p) {
                    final score = round.playerScores[p.id] ?? 0;
                    return '${p.name}: $score';
                  }).join(' | ');
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('El ${round.roundNumber}'),
                      subtitle: Text(entries),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Düzenle',
                            onPressed: () => _showEditSheet(round),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Sil',
                            onPressed: () => _confirmDelete(round),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
