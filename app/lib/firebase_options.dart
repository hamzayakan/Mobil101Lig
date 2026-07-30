import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase yapılandırması.
///
/// Gerçek değerler için proje kökünde `flutterfire configure` çalıştırın.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions bu platform için yapılandırılmamış.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_WEB_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_WEB_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_MESSAGING_SENDER_ID',
    projectId: 'REPLACE_WITH_FLUTTERFIRE_PROJECT_ID',
    authDomain: 'REPLACE_WITH_FLUTTERFIRE_AUTH_DOMAIN',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_ANDROID_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_MESSAGING_SENDER_ID',
    projectId: 'REPLACE_WITH_FLUTTERFIRE_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_IOS_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_MESSAGING_SENDER_ID',
    projectId: 'REPLACE_WITH_FLUTTERFIRE_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_IOS_API_KEY',
    appId: 'REPLACE_WITH_FLUTTERFIRE_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_MESSAGING_SENDER_ID',
    projectId: 'REPLACE_WITH_FLUTTERFIRE_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_STORAGE_BUCKET',
    iosBundleId: 'com.example.app',
  );
}
