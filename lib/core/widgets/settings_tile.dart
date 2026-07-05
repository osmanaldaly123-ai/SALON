import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'salon_card.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SalonListCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: Icon(icon, color: theme.colorScheme.primary, size: 22),
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.mutedForeground,
                )
              : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.p),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: theme.textTheme.muted),
          ],
        ],
      ),
    );
  }
}
