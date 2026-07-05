import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../di/injection.dart';
import '../router/route_names.dart';
import '../services/guest_session_service.dart';
import '../../l10n/app_localizations.dart';

class GuestGuard {
  GuestGuard._();

  static bool get isGuest => sl<GuestSessionService>().isGuest;

  /// Returns `true` if the action is allowed (user is signed in).
  static Future<bool> requireAccount(BuildContext context) async {
    if (!isGuest) return true;

    final l10n = AppLocalizations.of(context)!;

    await showShadDialog<void>(
      context: context,
      builder: (ctx) => ShadDialog.alert(
        title: Text(l10n.guestActionBlocked),
        description: Text(l10n.signInToContinue),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ShadButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(RouteNames.login);
            },
            child: Text(l10n.login),
          ),
        ],
      ),
    );

    return false;
  }

  static Future<void> runIfAllowed(
    BuildContext context,
    VoidCallback action,
  ) async {
    if (await requireAccount(context)) action();
  }
}
