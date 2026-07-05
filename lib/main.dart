import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/firebase_config.dart';
import 'core/di/injection.dart';
import 'features/notifications/services/firebase_messaging_background.dart';
import 'features/notifications/services/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  if (isFirebaseEnabled) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final notificationService = sl<NotificationService>();
    await notificationService.initialize();
    await notificationService.syncTokenWithBackend();
  }

  runApp(const SalonApp());
}
