import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../router/app_router.dart';
import '../router/route_names.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../l10n/app_localizations.dart';

class SessionExpiredHandler {
  SessionExpiredHandler(this._authBloc);

  final AuthBloc _authBloc;

  void handle() {
    _authBloc.add(const AuthSessionExpired());

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      ShadSonner.of(context).show(
        ShadToast.destructive(title: Text(l10n.sessionExpired)),
      );
    }
    context.go(RouteNames.login);
  }
}
