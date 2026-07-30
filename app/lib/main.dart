import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_router.dart';
import 'services/firebase/firebase_initializer.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();

  runApp(
    const ProviderScope(
      child: Mobil101LigApp(),
    ),
  );
}

/// Mobil101Lig uygulama kök widget'ı.
class Mobil101LigApp extends StatelessWidget {
  const Mobil101LigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mobil101Lig',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
