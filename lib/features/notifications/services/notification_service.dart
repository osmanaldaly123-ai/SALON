import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/firebase_config.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../utils/notification_navigation.dart';

typedef ForegroundNotificationHandler = void Function(RemoteMessage message);

class NotificationService {
  NotificationService(
    this._repository,
    this._authRepository,
    this._prefs,
  );

  final NotificationRepository _repository;
  final AuthRepository _authRepository;
  final SharedPreferences _prefs;

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  ForegroundNotificationHandler? onForegroundMessage;

  Future<void> initialize() async {
    if (!isFirebaseEnabled) return;
    await _requestPermissions();
    await _configurePlatformSettings();
    _listenForMessages();
    await _handleInitialMessage();
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configurePlatformSettings() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void _listenForMessages() {
    _foregroundSubscription?.cancel();
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      onForegroundMessage?.call(message);
    });

    _openedAppSubscription?.cancel();
    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      NotificationNavigation.handle,
    );

    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) => _registerToken(token),
    );
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      NotificationNavigation.handle(message);
    }
  }

  Future<void> syncTokenWithBackend() async {
    if (!isFirebaseEnabled) return;
    if (!await _authRepository.isLoggedIn()) return;

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    final cached = _prefs.getString(AppConstants.fcmTokenKey);
    if (cached == token) return;

    await _registerToken(token);
  }

  Future<void> _registerToken(String token) async {
    if (!await _authRepository.isLoggedIn()) return;

    try {
      await _repository.registerToken(
        token: token,
        platform: NotificationNavigation.platformName(),
      );
      await _prefs.setString(AppConstants.fcmTokenKey, token);
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }

  Future<void> clearTokenOnLogout() async {
    if (!isFirebaseEnabled) return;
    try {
      if (_prefs.containsKey(AppConstants.fcmTokenKey)) {
        await _repository.unregisterToken();
      }
    } catch (e) {
      debugPrint('FCM token unregister failed: $e');
    } finally {
      await _prefs.remove(AppConstants.fcmTokenKey);
    }
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _foregroundSubscription?.cancel();
    _openedAppSubscription?.cancel();
  }
}
