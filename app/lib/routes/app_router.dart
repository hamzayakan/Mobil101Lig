import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/game/presentation/screens/yazboz_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/league/presentation/screens/league_detail_screen.dart';
import '../features/league/presentation/screens/leagues_screen.dart';
import 'route_names.dart';

/// Uygulama router yapılandırması.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.yazboz,
        builder: (context, state) => const YazbozScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.leagues,
        builder: (context, state) => const LeaguesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => LeagueDetailScreen(
              leagueId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Hata')),
      body: Center(child: Text('Sayfa bulunamadı: ${state.uri}')),
    ),
  );
}
