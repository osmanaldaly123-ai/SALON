import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../auth/domain/entities/user.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Column(
      children: [
        ShadAvatar(
          hasAvatar ? user.avatarUrl : null,
          size: const Size(96, 96),
          placeholder: Text(
            initial,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: theme.textTheme.h3),
        const SizedBox(height: 4),
        Text(user.email, style: theme.textTheme.muted),
        if (user.phone != null && user.phone!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(user.phone!, style: theme.textTheme.muted),
        ],
      ],
    );
  }
}
