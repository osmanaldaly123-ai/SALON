// File generated from android/app/google-services.json
// (com.salonbooking.app — matches flutterfire configure output)
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  /// Set to `true` after adding `GoogleService-Info.plist` and iOS options below.
  static const bool iosConfigured = true;

  static bool isConfiguredFor(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return true;
      case TargetPlatform.iOS:
        return iosConfigured;
      default:
        return false;
    }
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        if (!iosConfigured) {
          throw UnsupportedError(
            'DefaultFirebaseOptions have not been configured for ios — '
            'see docs/IOS_SETUP.md',
          );
        }
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux — '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcPisVgCjyGGDkLDeL7vjBwvNY8vH0r94',
    appId: '1:920429460532:android:37a64dacfd243c89ddde61',
    messagingSenderId: '920429460532',
    projectId: 'salonbookingapp-dd24d',
    storageBucket: 'salonbookingapp-dd24d.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAo8xEqXeZgJjOL21SCFTW54Ms54oncXXA',
    appId: '1:920429460532:ios:def82f69b204f668ddde61',
    messagingSenderId: '920429460532',
    projectId: 'salonbookingapp-dd24d',
    storageBucket: 'salonbookingapp-dd24d.firebasestorage.app',
    iosBundleId: 'com.salonbooking.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDbwjTOVJtYdOXIfVlVFwGPJ02iSZ1ds0',
    appId: '1:551770431072:web:e2b55c6f9cf072b3a0ad05',
    messagingSenderId: '551770431072',
    projectId: 'system-42ab7',
    authDomain: 'system-42ab7.firebaseapp.com',
    storageBucket: 'system-42ab7.firebasestorage.app',
    measurementId: 'G-Y6JP2TYDE8',
  );

  /// Realtime Database project (system-42ab7) — uses web app credentials.
  static const FirebaseOptions databaseProject = web;

  /// Default RTDB URL — verify in Firebase Console → Realtime Database.
  static const String defaultDatabaseUrl =
      'https://system-42ab7-default-rtdb.firebaseio.com';

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAo8xEqXeZgJjOL21SCFTW54Ms54oncXXA',
    appId: '1:920429460532:ios:d7cc04aef2358e7cddde61',
    messagingSenderId: '920429460532',
    projectId: 'salonbookingapp-dd24d',
    storageBucket: 'salonbookingapp-dd24d.firebasestorage.app',
    iosBundleId: 'com.example.myEwesomeApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDDbwjTOVJtYdOXIfVlVFwGPJ02iSZ1ds0',
    appId: '1:551770431072:web:e2b55c6f9cf072b3a0ad05',
    messagingSenderId: '551770431072',
    projectId: 'system-42ab7',
    authDomain: 'system-42ab7.firebaseapp.com',
    storageBucket: 'system-42ab7.firebasestorage.app',
    measurementId: 'G-Y6JP2TYDE8',
  );
}
