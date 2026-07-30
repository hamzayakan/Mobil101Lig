import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game/presentation/providers/game_providers.dart';
import '../../../../core/errors/league_exception.dart';
import '../providers/league_providers.dart';

/// Lig detayı, sıralama, üye ekleme ve oyun geçmişi.
class LeagueDetailScreen extends ConsumerStatefulWidget {
  const LeagueDetailScreen({
    super.key,
    required this.leagueId,
  });

  final String leagueId;

  @override
  ConsumerState<LeagueDetailScreen> createState() =>
      _LeagueDetailScreenState();
}

class _LeagueDetailScreenState extends ConsumerState<LeagueDetailScreen> {
  Future<void> _showAddMemberDialog() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var isSubmitting = false;
    String? errorMessage;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Üye Ekle'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      enabled: !isSubmitting,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-posta',
                        hintText: 'ornek@gmail.com',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'E-posta gerekli';
                        }
                        if (!value.contains('@')) {
                          return 'Geçerli e-posta girin';
                        }
                        return null;
                      },
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSubmitting ? null : () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          setDialogState(() {
                            isSubmitting = true;
                            errorMessage = null;
                          });

                          try {
                            await ref
                                .read(addLeagueMemberUseCaseProvider)
                                .execute(
                                  leagueId: widget.leagueId,
                                  email: controller.text,
                                );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } on LeagueException catch (error) {
                            setDialogState(() {
                              isSubmitting = false;
                              errorMessage = error.message;
                            });
                          } catch (error) {
                            setDialogState(() {
                              isSubmitting = false;
                              errorMessage = 'Üye eklenemedi: $error';
                            });
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
    ref.invalidate(leagueMembersProvider(widget.leagueId));
  }

  @override
  Widget build(BuildContext context) {
    final leagueAsync = ref.watch(leagueProvider(widget.leagueId));
    final membersAsync = ref.watch(leagueMembersProvider(widget.leagueId));
    final gamesAsync = ref.watch(leagueGamesProvider(widget.leagueId));

    return Scaffold(
      appBar: AppBar(
        title: leagueAsync.when(
          data: (league) => Text(league?.name ?? 'Lig'),
          loading: () => const Text('Lig'),
          error: (_, _) => const Text('Lig'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMemberDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Üye Ekle'),
      ),
      body: leagueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(_mapError(error))),
        data: (league) {
          if (league == null) {
            return const Center(child: Text('Lig bulunamadı.'));
          }

          return membersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(_mapError(error))),
            data: (members) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.emoji_events_outlined),
                      title: Text(league.name),
                      subtitle: Text('${members.length} üye'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sıralama',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '101 kuralı: düşük toplam skor üst sırada',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  if (members.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Henüz üye yok.'),
                      ),
                    )
                  else
                    ...members.asMap().entries.map((entry) {
                      final index = entry.key;
                      final member = entry.value;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(member.displayName),
                          subtitle: Text('${member.gamesPlayed} oyun'),
                          trailing: Text(
                            '${member.totalScore}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),
                  Text(
                    'Oyun Geçmişi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  gamesAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => Text(_mapError(error)),
                    data: (games) {
                      if (games.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Henüz kayıtlı oyun yok.'),
                          ),
                        );
                      }

                      return Column(
                        children: games.map((game) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.sports_esports),
                              title: Text(
                                '${game.playerCount} oyuncu • '
                                '${game.gameType.name == 'team' ? 'Eşli' : 'Tekli'}',
                              ),
                              subtitle: Text(
                                game.createdAt != null
                                    ? _formatDate(game.createdAt!)
                                    : 'Tarih yok',
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _mapError(Object error) {
    if (error is LeagueException) {
      return error.message;
    }
    return 'Veri yüklenemedi: $error';
  }
}
