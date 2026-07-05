import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/booking.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.circleCheck,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.bookingConfirmed,
                style: theme.textTheme.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bookingConfirmedSubtitle,
                style: theme.textTheme.muted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _DetailTile(
                icon: LucideIcons.store,
                label: l10n.salons,
                value: booking.salonName ?? '—',
              ),
              _DetailTile(
                icon: LucideIcons.scissors,
                label: l10n.services,
                value: booking.serviceName ?? '—',
              ),
              _DetailTile(
                icon: LucideIcons.clock,
                label: l10n.dateTime,
                value: DateFormat.yMMMd().add_Hm().format(booking.dateTime),
              ),
              const Spacer(),
              SalonButton(
                fullWidth: true,
                onPressed: () => context.go(RouteNames.home),
                child: Text(l10n.backToHome),
              ),
              const SizedBox(height: 12),
              SalonButton(
                fullWidth: true,
                variant: SalonButtonVariant.outline,
                onPressed: () => context.go(RouteNames.bookingHistory),
                child: Text(l10n.bookingHistory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.muted),
                Text(
                  value,
                  style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
