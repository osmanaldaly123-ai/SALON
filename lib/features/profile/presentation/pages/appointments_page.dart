import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../../../core/widgets/main_layout.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../l10n/app_localizations.dart';
import 'booking_history_page.dart';

/// Tab screen for "مواعيدي" — matches mockup bottom navigation.
class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);
    final isGuest = sl<GuestSessionService>().isGuest;

    return MainLayout(
      currentIndex: MainTabIndex.appointments,
      child: isGuest
          ? Scaffold(
              backgroundColor: theme.colorScheme.background,
              appBar: AppBar(
                backgroundColor: theme.colorScheme.background,
                foregroundColor: theme.colorScheme.foreground,
                title: Text(l10n.myAppointments),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 72,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.appointmentsGuestTitle,
                      style: theme.textTheme.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appointmentsGuestSubtitle,
                      style: theme.textTheme.muted,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SalonButton(
                      fullWidth: true,
                      onPressed: () => context.go(RouteNames.login),
                      child: Text(l10n.login),
                    ),
                    const SizedBox(height: 12),
                    SalonButton(
                      fullWidth: true,
                      variant: SalonButtonVariant.outline,
                      onPressed: () => context.go(RouteNames.register),
                      child: Text(l10n.register),
                    ),
                  ],
                ),
              ),
            )
          : const BookingHistoryPage(showBackButton: false),
    );
  }
}
