import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/widgets/salon_button.dart';
import '../../../../core/widgets/salon_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../booking/domain/entities/booking.dart';

class BookingHistoryTile extends StatelessWidget {
  const BookingHistoryTile({
    super.key,
    required this.booking,
    this.onCancel,
    this.isCancelling = false,
  });

  final Booking booking;
  final VoidCallback? onCancel;
  final bool isCancelling;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return SalonListCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.salonName ?? l10n.salons,
                  style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              _LocalizedStatusBadge(status: booking.status, l10n: l10n),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                LucideIcons.scissors,
                size: 16,
                color: theme.colorScheme.mutedForeground,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  booking.serviceName ?? l10n.services,
                  style: theme.textTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                LucideIcons.clock,
                size: 16,
                color: theme.colorScheme.mutedForeground,
              ),
              const SizedBox(width: 6),
              Text(
                DateFormat.yMMMd().add_Hm().format(booking.dateTime),
                style: theme.textTheme.muted,
              ),
            ],
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: SalonButton(
                variant: SalonButtonVariant.ghost,
                onPressed: isCancelling ? null : onCancel,
                isLoading: isCancelling,
                child: Text(
                  l10n.cancelBooking,
                  style: TextStyle(color: theme.colorScheme.destructive),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LocalizedStatusBadge extends StatelessWidget {
  const _LocalizedStatusBadge({required this.status, required this.l10n});

  final BookingStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final label = switch (status) {
      BookingStatus.pending => l10n.statusPending,
      BookingStatus.confirmed => l10n.statusConfirmed,
      BookingStatus.completed => l10n.statusCompleted,
      BookingStatus.cancelled => l10n.statusCancelled,
    };

    final color = switch (status) {
      BookingStatus.pending => Colors.orange,
      BookingStatus.confirmed => theme.colorScheme.primary,
      BookingStatus.completed => theme.colorScheme.mutedForeground,
      BookingStatus.cancelled => theme.colorScheme.destructive,
    };

    return ShadBadge.secondary(
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
