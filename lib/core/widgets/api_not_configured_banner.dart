import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../config/app_config.dart';
import '../../l10n/app_localizations.dart';

/// Shown on auth screens when [AppConfig.isApiConfigured] is false.
class ApiNotConfiguredBanner extends StatelessWidget {
  const ApiNotConfiguredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.isApiConfigured) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ShadAlert(
        icon: Icon(LucideIcons.info, color: theme.colorScheme.primary),
        title: Text(l10n.apiNotConfiguredTitle),
        description: Text(l10n.apiNotConfiguredMessage),
      ),
    );
  }
}
