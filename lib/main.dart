import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/firebase_config.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_initializer.dart';
import 'features/notifications/services/firebase_messaging_background.dart';
import 'features/notifications/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  await FirebaseInitializer.ensureInitialized();

  if (isFirebaseMessagingEnabled) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final notificationService = sl<NotificationService>();
    await notificationService.initialize();
    await notificationService.syncTokenWithBackend();
  }

  runApp(const SalonApp());
}
