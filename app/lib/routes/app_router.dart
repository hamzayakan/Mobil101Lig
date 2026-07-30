import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/game/presentation/screens/yazboz_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
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
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Hata')),
      body: Center(child: Text('Sayfa bulunamadı: ${state.uri}')),
    ),
  );
}
