import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../routes/route_names.dart';

/// Ana ekran — feature giriş noktaları.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Mobil101Lig')),
        body: Center(child: Text('Oturum yüklenemedi: $error')),
      ),
      data: (user) => _HomeContent(user: user),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = user;
    final isLoggedIn = currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobil101Lig'),
        actions: [
          if (currentUser != null)
            IconButton(
              onPressed: () async {
                await ref.read(signOutUseCaseProvider).execute();
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Çıkış Yap',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (currentUser != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: currentUser.photoUrl != null
                      ? NetworkImage(currentUser.photoUrl!)
                      : null,
                  child: currentUser.photoUrl == null
                      ? Text(
                          currentUser.displayName.isNotEmpty
                              ? currentUser.displayName[0].toUpperCase()
                              : '?',
                        )
                      : null,
                ),
                title: Text('Merhaba, ${currentUser.displayName}'),
                subtitle: Text(currentUser.email),
              ),
            ),
          if (currentUser != null) const SizedBox(height: 16),
          Text(
            '101 Oyun Takip',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Arkadaş grubunuzla oyun sonuçlarını dijital yazboz ile takip edin.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _FeatureCard(
            icon: Icons.scoreboard_outlined,
            title: '101 Yazboz',
            subtitle:
                'El bazlı skor girişi, toplam hesaplama, tekli ve eşli oyun',
            onTap: () => context.push(RouteNames.yazboz),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            key: const Key('home_leagues_card'),
            icon: Icons.groups_outlined,
            title: 'Ligler',
            subtitle: isLoggedIn
                ? 'Lig oluştur, üyeleri gör, sıralamayı takip et'
                : 'Ligler için giriş yapın',
            onTap: isLoggedIn
                ? () => context.push(RouteNames.leagues)
                : () => context.push(RouteNames.login),
            enabled: true,
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            key: const Key('home_login_card'),
            icon: Icons.login,
            title: isLoggedIn ? 'Hesabım' : 'Giriş Yap',
            subtitle: isLoggedIn
                ? 'Google hesabınızla oturum açık'
                : 'Google hesabı ile giriş yapın',
            onTap: isLoggedIn
                ? () {}
                : () => context.push(RouteNames.login),
            enabled: !isLoggedIn,
            trailing: isLoggedIn ? Icons.check_circle : Icons.chevron_right,
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
    this.trailing = Icons.chevron_right,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: enabled ? null : Colors.grey),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          trailing,
          color: enabled ? null : Colors.green,
        ),
        enabled: enabled,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
