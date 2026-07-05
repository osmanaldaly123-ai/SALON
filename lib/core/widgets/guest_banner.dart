import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../di/injection.dart';
import '../router/route_names.dart';
import '../services/guest_session_service.dart';
import '../../l10n/app_localizations.dart';
import 'salon_button.dart';

class GuestBanner extends StatelessWidget {
  const GuestBanner({
    super.key,
    required this.onDismiss,
  });

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    if (!sl<GuestSessionService>().isGuest) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ShadCard(
        padding: const EdgeInsets.all(16),
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.userRound,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.guestBannerTitle,
                        style: theme.textTheme.p.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.guestBannerMessage,
                        style: theme.textTheme.muted,
                      ),
                    ],
                  ),
                ),
                ShadButton.ghost(
                  onPressed: onDismiss,
                  child: const Icon(LucideIcons.x, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SalonButton(
                    onPressed: () => context.go(RouteNames.login),
                    child: Text(l10n.login),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SalonButton(
                    variant: SalonButtonVariant.outline,
                    onPressed: () => context.go(RouteNames.register),
                    child: Text(l10n.register),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
