import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/widgets/settings_tile.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);
    final localeService = sl<LocaleService>();
    final isGuest = sl<GuestSessionService>().isGuest;
    final languageLabel =
        localeService.locale.languageCode == 'ar' ? 'العربية' : 'English';

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        title: Text(l10n.settings),
        leading: ShadButton.ghost(
          onPressed: () => context.canPop() ? context.pop() : context.go(RouteNames.profile),
          child: const Icon(LucideIcons.arrowLeft, size: 20),
        ),
        leadingWidth: 56,
      ),
      body: ListenableBuilder(
        listenable: localeService,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsGeneral,
                  style: theme.textTheme.muted.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SettingsTile(
                  icon: LucideIcons.languages,
                  title: l10n.language,
                  trailing: Text(
                    languageLabel,
                    style: theme.textTheme.muted,
                  ),
                  onTap: localeService.toggleLocale,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.settingsAbout,
                  style: theme.textTheme.muted.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SettingsTile(
                  icon: LucideIcons.info,
                  title: l10n.appVersion,
                  trailing: Text(
                    AppConfig.appVersion,
                    style: theme.textTheme.muted,
                  ),
                ),
                if (isGuest) ...[
                  const SizedBox(height: 24),
                  Text(
                    l10n.settingsAccount,
                    style: theme.textTheme.muted.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SettingsTile(
                    icon: LucideIcons.logIn,
                    title: l10n.login,
                    subtitle: l10n.guestModeSubtitle,
                    onTap: () => context.go(RouteNames.login),
                  ),
                  SettingsTile(
                    icon: LucideIcons.userPlus,
                    title: l10n.register,
                    onTap: () => context.go(RouteNames.register),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
