import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_initializer.dart';

/// Firebase Auth bound to the same app as Realtime Database (system-42ab7).
class FirebaseAuthClient {
  FirebaseAuth get instance => FirebaseAuth.instanceFor(
        app: FirebaseInitializer.databaseApp(),
      );

  User? get currentUser => instance.currentUser;
}
