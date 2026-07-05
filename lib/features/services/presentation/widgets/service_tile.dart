import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/salon_card.dart';
import '../../domain/entities/service.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.service,
    this.onTap,
    this.trailing,
  });

  final Service service;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SalonListCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: AppNetworkImage(
        imageUrl: service.imageUrl,
        width: 56,
        height: 56,
        borderRadius: 12,
        icon: LucideIcons.scissors,
      ),
      trailing: trailing ??
          Text(
            AppFormatters.price(service.price),
            style: theme.textTheme.p.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
          ),
          if (service.description != null) ...[
            const SizedBox(height: 2),
            Text(
              service.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.muted,
            ),
          ],
          if (service.durationMinutes != null) ...[
            const SizedBox(height: 4),
            Text(
              AppFormatters.duration(service.durationMinutes),
              style: theme.textTheme.muted,
            ),
          ],
        ],
      ),
    );
  }
}
