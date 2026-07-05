import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/salon_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/booking_draft.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.draft});

  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SalonListCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _Row(label: l10n.salons, value: draft.salonName ?? '—'),
          const ShadSeparator.horizontal(margin: EdgeInsets.symmetric(vertical: 12)),
          _Row(label: l10n.services, value: draft.serviceName ?? '—'),
          if (draft.price != null) ...[
            const ShadSeparator.horizontal(margin: EdgeInsets.symmetric(vertical: 12)),
            _Row(
              label: l10n.price,
              value: AppFormatters.price(draft.price!),
              highlight: true,
            ),
          ],
          if (draft.slot != null) ...[
            const ShadSeparator.horizontal(margin: EdgeInsets.symmetric(vertical: 12)),
            _Row(
              label: l10n.dateTime,
              value: DateFormat.yMMMd().add_Hm().format(draft.slot!),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: theme.textTheme.muted),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: highlight
                ? theme.textTheme.p.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
