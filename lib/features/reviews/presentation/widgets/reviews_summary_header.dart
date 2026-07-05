import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';

class ReviewsSummaryHeader extends StatelessWidget {
  const ReviewsSummaryHeader({
    super.key,
    required this.averageRating,
    required this.reviewCount,
  });

  final double averageRating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return ShadCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.06),
      child: Row(
        children: [
          Text(
            AppFormatters.rating(averageRating),
            style: theme.textTheme.h2.copyWith(color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 8),
          Icon(LucideIcons.star, color: theme.colorScheme.primary, size: 28),
          const Spacer(),
          Text(
            l10n.reviewCount(reviewCount),
            style: theme.textTheme.muted,
          ),
        ],
      ),
    );
  }
}
