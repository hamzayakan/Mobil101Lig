import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Firebase başlatma servisi.
abstract final class FirebaseInitializer {
  static bool _initialized = false;

  /// Firebase başarıyla başlatıldı mı?
  static bool get isInitialized => _initialized;

  /// Firebase uygulamasını başlatır.
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('Firebase başlatılamadı: $error');
      debugPrint('$stackTrace');
    }
  }
}
