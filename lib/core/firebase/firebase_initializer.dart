import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../config/firebase_config.dart';
import '../../firebase_options.dart';

/// Ensures [Firebase.initializeApp] runs once when Core or Database is needed.
class FirebaseInitializer {
  FirebaseInitializer._();

  static const String databaseAppName = 'salon_rtdb';

  static Future<void>? _initFuture;

  static Future<void> ensureInitialized() {
    if (!shouldInitializeFirebase) return Future.value();
    _initFuture ??= _initialize();
    return _initFuture!;
  }

  /// Firebase app used for Realtime Database reads.
  static FirebaseApp databaseApp() {
    if (_usesSecondaryDatabaseApp) {
      return Firebase.app(databaseAppName);
    }
    return Firebase.app();
  }

  static bool get _usesSecondaryDatabaseApp =>
      Env.isFirebaseDatabaseConfigured &&
      !kIsWeb &&
      Env.firebaseDatabaseUrl.contains('system-42ab7');

  static Future<void> _initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (_usesSecondaryDatabaseApp) {
      try {
        await Firebase.initializeApp(
          name: databaseAppName,
          options: DefaultFirebaseOptions.databaseProject,
        );
      } on FirebaseException catch (e) {
        if (e.code != 'duplicate-app') rethrow;
      }
    }
  }
}
