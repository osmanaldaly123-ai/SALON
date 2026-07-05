import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/main_layout.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../core/widgets/settings_tile.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = sl<LocaleService>();
    final theme = ShadTheme.of(context);
    final isGuest = sl<GuestSessionService>().isGuest;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthUnauthenticated,
      listener: (context, state) => context.go(RouteNames.login),
      child: MainLayout(
        currentIndex: MainTabIndex.profile,
        child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            foregroundColor: theme.colorScheme.foreground,
            title: Text(l10n.account),
            centerTitle: true,
          ),
          body: isGuest
              ? _GuestProfileContent(
                  l10n: l10n,
                  localeCode: localeService.locale.languageCode,
                )
              : BlocProvider.value(
                  value: sl<ProfileCubit>()..load(),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return switch (state) {
                        ProfileLoading() =>
                          AppLoadingIndicator(message: l10n.loading),
                        ProfileFailure(:final message) => AppErrorWidget(
                            message: ValidationMessages.resolveError(
                              context,
                              message,
                            ),
                            onRetry: () => context.read<ProfileCubit>().load(),
                          ),
                        ProfileLoaded(:final user) ||
                        ProfileUpdating(:final user) =>
                          _ProfileContent(
                            user: user,
                            isUpdating: state is ProfileUpdating,
                            l10n: l10n,
                            localeCode: localeService.locale.languageCode,
                          ),
                      };
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class _GuestProfileContent extends StatelessWidget {
  const _GuestProfileContent({
    required this.l10n,
    required this.localeCode,
  });

  final AppLocalizations l10n;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final languageLabel = localeCode == 'ar' ? 'العربية' : 'English';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(
              LucideIcons.userRound,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.guestModeTitle,
            style: theme.textTheme.h3,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.guestModeSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.muted,
          ),
          const SizedBox(height: 24),
          SalonButton(
            fullWidth: true,
            onPressed: () => context.go(RouteNames.login),
            child: Text(l10n.login),
          ),
          const SizedBox(height: 12),
          SalonButton(
            fullWidth: true,
            variant: SalonButtonVariant.outline,
            onPressed: () => context.go(RouteNames.register),
            child: Text(l10n.register),
          ),
          const SizedBox(height: 24),
          SettingsTile(
            icon: LucideIcons.settings,
            title: l10n.settings,
            onTap: () => context.push(RouteNames.settings),
          ),
          SettingsTile(
            icon: LucideIcons.languages,
            title: l10n.language,
            trailing: Text(
              languageLabel,
              style: theme.textTheme.muted,
            ),
            onTap: () => sl<LocaleService>().toggleLocale(),
          ),
          const SizedBox(height: 32),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SalonButton(
                fullWidth: true,
                variant: SalonButtonVariant.outline,
                onPressed: isLoading
                    ? null
                    : () => context
                        .read<AuthBloc>()
                        .add(const AuthLogoutRequested()),
                isLoading: isLoading,
                child: Text(l10n.exitGuestMode),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.user,
    required this.isUpdating,
    required this.l10n,
    required this.localeCode,
  });

  final User user;
  final bool isUpdating;
  final AppLocalizations l10n;
  final String localeCode;

  Future<void> _openEdit(BuildContext context) async {
    final updated = await context.push<bool>(
      RouteNames.editProfile,
      extra: user,
    );
    if (updated == true && context.mounted) {
      context.read<ProfileCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final languageLabel = localeCode == 'ar' ? 'العربية' : 'English';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ProfileHeader(user: user),
          const SizedBox(height: 24),
          SalonButton(
            fullWidth: true,
            variant: SalonButtonVariant.outline,
            onPressed: isUpdating
                ? null
                : () => GuestGuard.runIfAllowed(context, () => _openEdit(context)),
            leading: const Icon(LucideIcons.pencil, size: 18),
            child: Text(l10n.editProfile),
          ),
          const SizedBox(height: 24),
          SettingsTile(
            icon: LucideIcons.history,
            title: l10n.myAppointments,
            onTap: () => GuestGuard.runIfAllowed(
              context,
              () => context.go(RouteNames.appointments),
            ),
          ),
          SettingsTile(
            icon: LucideIcons.settings,
            title: l10n.settings,
            onTap: () => context.push(RouteNames.settings),
          ),
          SettingsTile(
            icon: LucideIcons.languages,
            title: l10n.language,
            trailing: Text(
              languageLabel,
              style: theme.textTheme.muted,
            ),
            onTap: () => sl<LocaleService>().toggleLocale(),
          ),
          const SizedBox(height: 32),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SalonButton(
                fullWidth: true,
                variant: SalonButtonVariant.destructive,
                onPressed: isLoading
                    ? null
                    : () => context
                        .read<AuthBloc>()
                        .add(const AuthLogoutRequested()),
                isLoading: isLoading,
                child: Text(l10n.logout),
              );
            },
          ),
        ],
      ),
    );
  }
}
