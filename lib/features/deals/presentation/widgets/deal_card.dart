import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/salon_card.dart';
import '../../domain/entities/deal.dart';

class DealCard extends StatelessWidget {
  const DealCard({
    super.key,
    required this.deal,
    required this.onTap,
    this.compact = false,
  });

  final Deal deal;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactDealCard(deal: deal, onTap: onTap);
    }
    return _FullDealCard(deal: deal, onTap: onTap);
  }
}

class _CompactDealCard extends StatelessWidget {
  const _CompactDealCard({required this.deal, required this.onTap});

  final Deal deal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SizedBox(
      width: 260,
      child: GestureDetector(
        onTap: onTap,
        child: ShadCard(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              AppNetworkImage(
                imageUrl: deal.imageUrl,
                width: 80,
                height: 80,
                borderRadius: 12,
                icon: LucideIcons.tag,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.p
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      ShadBadge.secondary(
                        child: Text(
                          AppFormatters.discount(deal.discountPercent),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullDealCard extends StatelessWidget {
  const _FullDealCard({required this.deal, required this.onTap});

  final Deal deal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SalonListCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppNetworkImage(
            imageUrl: deal.imageUrl,
            height: 140,
            borderRadius: 12,
            icon: LucideIcons.tag,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        deal.title,
                        style: theme.textTheme.p
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    ShadBadge.secondary(
                      child: Text(
                        AppFormatters.discount(deal.discountPercent),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (deal.description != null) ...[
                  const SizedBox(height: 8),
                  Text(deal.description!, style: theme.textTheme.muted),
                ],
                if (deal.validUntil != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 16,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppFormatters.dealExpiry(deal.validUntil),
                        style: theme.textTheme.muted,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
