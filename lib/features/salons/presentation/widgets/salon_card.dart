import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/salon_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/salon.dart';

class SalonCard extends StatelessWidget {
  const SalonCard({
    super.key,
    required this.salon,
    required this.onTap,
    this.compact = false,
  });

  final Salon salon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactSalonCard(salon: salon, onTap: onTap);
    }
    return _FullSalonCard(salon: salon, onTap: onTap);
  }
}

class _CompactSalonCard extends StatelessWidget {
  const _CompactSalonCard({required this.salon, required this.onTap});

  final Salon salon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNetworkImage(
              imageUrl: salon.imageUrl,
              height: 120,
              width: 200,
              borderRadius: 12,
            ),
            const SizedBox(height: 8),
            Text(
              salon.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (salon.rating != null) ...[
                  Icon(
                    LucideIcons.star,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    AppFormatters.rating(salon.rating),
                    style: theme.textTheme.muted,
                  ),
                ],
                if (salon.distance != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.mapPin,
                    size: 14,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    AppFormatters.distance(salon.distance),
                    style: theme.textTheme.muted,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FullSalonCard extends StatelessWidget {
  const _FullSalonCard({required this.salon, required this.onTap});

  final Salon salon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SalonListCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      leading: AppNetworkImage(
        imageUrl: salon.imageUrl,
        width: 88,
        height: 88,
        borderRadius: 12,
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        color: theme.colorScheme.mutedForeground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            salon.name,
            style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
          ),
          if (salon.address != null) ...[
            const SizedBox(height: 4),
            Text(
              salon.address!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.muted,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              if (salon.rating != null) RatingBadge(rating: salon.rating!),
              if (salon.distance != null) ...[
                const SizedBox(width: 8),
                Text(
                  AppFormatters.distance(salon.distance),
                  style: theme.textTheme.muted,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
