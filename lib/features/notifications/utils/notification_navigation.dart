import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/router/route_names.dart';
import 'package:go_router/go_router.dart';

/// Routes the user when they tap a push notification.
class NotificationNavigation {
  NotificationNavigation._();

  static void handle(RemoteMessage message) {
    handleData(message.data);
  }

  static void handleData(Map<String, dynamic> data) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final type = data['type']?.toString() ?? '';
    switch (type) {
      case 'booking':
      case 'booking_reminder':
        context.go(RouteNames.bookingHistory);
      case 'salon':
        final salonId = data['salon_id']?.toString();
        if (salonId != null && salonId.isNotEmpty) {
          context.go('/salons/$salonId');
        } else {
          context.go(RouteNames.salons);
        }
      case 'deal':
        context.go(RouteNames.deals);
      case 'profile':
        context.go(RouteNames.profile);
      default:
        context.go(RouteNames.home);
    }
  }

  static String platformName() {
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
    if (defaultTargetPlatform == TargetPlatform.android) return 'android';
    return 'unknown';
  }
}
