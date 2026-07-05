import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import 'env.dart';

/// Whether Firebase Core should be initialized (messaging and/or database).
bool get shouldInitializeFirebase {
  if (Env.isFirebaseDatabaseConfigured) return true;
  if (kIsWeb) return false;
  return DefaultFirebaseOptions.isConfiguredFor(defaultTargetPlatform);
}

/// Whether Firebase Cloud Messaging (push) is available on this platform.
bool get isFirebaseMessagingEnabled {
  if (kIsWeb) return false;
  if (!DefaultFirebaseOptions.isConfiguredFor(defaultTargetPlatform)) {
    return false;
  }
  return true;
}

/// @deprecated Use [isFirebaseMessagingEnabled]. Kept for existing call sites.
bool get isFirebaseEnabled => isFirebaseMessagingEnabled;
