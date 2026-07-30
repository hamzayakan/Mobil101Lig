import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/errors/league_exception.dart';
import '../../../../routes/route_names.dart';
import '../providers/league_providers.dart';

/// Kullanıcının liglerini listeler.
class LeaguesScreen extends ConsumerStatefulWidget {
  const LeaguesScreen({super.key});

  @override
  ConsumerState<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends ConsumerState<LeaguesScreen> {
  Future<void> _showCreateLeagueDialog(UserEntity user) async {
    final leagueId = await showDialog<String?>(
      context: context,
      builder: (dialogContext) => _CreateLeagueDialog(user: user),
    );

    if (!mounted || leagueId == null) {
      return;
    }

    ref.invalidate(userLeaguesProvider(user.id));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.push(RouteNames.leagueDetail(leagueId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ligler')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ligleri görmek için giriş yapın.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.push(RouteNames.login),
                child: const Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      );
    }

    final leaguesAsync = ref.watch(userLeaguesProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ligler'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateLeagueDialog(user),
        icon: const Icon(Icons.add),
        label: const Text('Lig Oluştur'),
      ),
      body: leaguesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: _mapError(error),
          onRetry: () => ref.invalidate(userLeaguesProvider(user.id)),
        ),
        data: (leagues) {
          if (leagues.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Henüz liginiz yok',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Arkadaş grubunuz için yeni bir lig oluşturun.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: leagues.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final league = leagues[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.emoji_events_outlined),
                  ),
                  title: Text(league.name),
                  subtitle: Text(
                    league.ownerId == user.id ? 'Sizin liginiz' : 'Üye',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.leagueDetail(league.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _mapError(Object error) {
    if (error is LeagueException) {
      return error.message;
    }
    return 'Ligler yüklenemedi: $error';
  }
}

class _CreateLeagueDialog extends ConsumerStatefulWidget {
  const _CreateLeagueDialog({required this.user});

  final UserEntity user;

  @override
  ConsumerState<_CreateLeagueDialog> createState() =>
      _CreateLeagueDialogState();
}

class _CreateLeagueDialogState extends ConsumerState<_CreateLeagueDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  var _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final league = await ref.read(createLeagueUseCaseProvider).execute(
            name: _controller.text,
            ownerId: widget.user.id,
            ownerDisplayName: widget.user.displayName,
          );

      if (mounted) {
        Navigator.of(context).pop(league.id);
      }
    } on LeagueException catch (error) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = error.message;
      });
    } catch (error) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Lig oluşturulamadı: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Lig'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Lig adı',
                hintText: 'Örn: 101 Ligimiz',
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lig adı gerekli';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Oluştur'),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
