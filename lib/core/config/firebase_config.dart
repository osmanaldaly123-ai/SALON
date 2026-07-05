import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Whether Firebase (FCM) should be initialized on the current platform.
bool get isFirebaseEnabled {
  if (kIsWeb) return false;
  return DefaultFirebaseOptions.isConfiguredFor(defaultTargetPlatform);
}
