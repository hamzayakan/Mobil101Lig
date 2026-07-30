import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase yapılandırması — `lig-2ab3b` projesi (google-services.json).
class DefaultFirebaseOptions {
  /// Google Sign-In için web OAuth client (google-services.json, client_type: 3).
  static const String googleWebClientId =
      '298154380644-m5sj1tna62ksddq9vnpth1m9at35qk7n.apps.googleusercontent.com';

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
    apiKey: 'AIzaSyBUyOS_O8TPhjIn9LW6y4ZOMKMK-ob2MeA',
    appId: '1:298154380644:web:047c1adb0b27559efb3e71',
    messagingSenderId: '298154380644',
    projectId: 'lig-2ab3b',
    authDomain: 'lig-2ab3b.firebaseapp.com',
    storageBucket: 'lig-2ab3b.firebasestorage.app',
    measurementId: 'G-4SRH912ZC5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYKGew4pIkab0aDJchBQhMWr8pOw6mQKw',
    appId: '1:298154380644:android:5dfc4c3965d74a53fb3e71',
    messagingSenderId: '298154380644',
    projectId: 'lig-2ab3b',
    storageBucket: 'lig-2ab3b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYKGew4pIkab0aDJchBQhMWr8pOw6mQKw',
    appId: '1:298154380644:android:5dfc4c3965d74a53fb3e71',
    messagingSenderId: '298154380644',
    projectId: 'lig-2ab3b',
    storageBucket: 'lig-2ab3b.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYKGew4pIkab0aDJchBQhMWr8pOw6mQKw',
    appId: '1:298154380644:android:5dfc4c3965d74a53fb3e71',
    messagingSenderId: '298154380644',
    projectId: 'lig-2ab3b',
    storageBucket: 'lig-2ab3b.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );
}
