import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/route_names.dart';

/// Ana ekran — feature giriş noktaları.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobil101Lig'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            subtitle: 'El bazlı skor girişi, toplam hesaplama, tekli ve eşli oyun',
            onTap: () => context.push(RouteNames.yazboz),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.groups_outlined,
            title: 'Ligler',
            subtitle: 'Yakında — lig oluşturma ve sıralama',
            enabled: false,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.login,
            title: 'Giriş Yap',
            subtitle: 'Yakında — Google hesabı ile giriş',
            enabled: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: enabled ? null : Colors.grey),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: enabled ? const Icon(Icons.chevron_right) : null,
        enabled: enabled,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
