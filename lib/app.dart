import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/config/firebase_config.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/locale_service.dart';
import 'core/theme/shad_salon_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/notifications/services/notification_service.dart';
import 'l10n/app_localizations.dart';

class SalonApp extends StatefulWidget {
  const SalonApp({super.key});

  @override
  State<SalonApp> createState() => _SalonAppState();
}

class _SalonAppState extends State<SalonApp> {
  late final GoRouter _router = createAppRouter();
  late final LocaleService _localeService = sl<LocaleService>();

  NotificationService? get _notificationService =>
      isFirebaseEnabled ? sl<NotificationService>() : null;

  @override
  void initState() {
    super.initState();
    _notificationService?.onForegroundMessage = _showForegroundNotification;
  }

  @override
  void dispose() {
    _notificationService?.onForegroundMessage = null;
    super.dispose();
  }

  void _showForegroundNotification(RemoteMessage message) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final title =
        message.notification?.title ?? message.data['title']?.toString();
    final body = message.notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) return;

    ShadSonner.of(context).show(
      ShadToast(
        title: Text(title ?? ''),
        description: body != null ? Text(body) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthAuthenticated,
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            await _notificationService?.syncTokenWithBackend();
          }
        },
        child: ListenableBuilder(
          listenable: _localeService,
          builder: (context, _) {
            return ShadApp.router(
              title: 'Salon',
              debugShowCheckedModeBanner: false,
              theme: SalonShadTheme.light,
              locale: _localeService.locale,
              supportedLocales: AppConstants.supportedLocales
                  .map((code) => Locale(code))
                  .toList(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: _router,
              builder: (context, child) {
                return Directionality(
                  textDirection: _localeService.isRtl
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: ShadSonner(
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
