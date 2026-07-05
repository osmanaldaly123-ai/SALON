import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ValidationMessages {
  ValidationMessages._();

  static String? resolve(BuildContext context, String? key) {
    if (key == null) return null;
    final l10n = AppLocalizations.of(context)!;
    return switch (key) {
      'required_field' => l10n.requiredField,
      'invalid_email' => l10n.invalidEmail,
      'password_too_short' => l10n.passwordTooShort,
      'invalid_phone' => l10n.invalidPhone,
      'passwords_do_not_match' => l10n.passwordsDoNotMatch,
      _ => key,
    };
  }

  static String resolveError(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    return switch (key) {
      'login_failed' => l10n.loginFailed,
      'register_failed' => l10n.registerFailed,
      'network_error' => l10n.networkError,
      'invalid_credentials' => l10n.invalidCredentials,
      'email_already_exists' => l10n.emailAlreadyExists,
      'load_failed' => l10n.loadFailed,
      'review_failed' => l10n.reviewFailed,
      'update_failed' => l10n.updateFailed,
      'cancel_failed' => l10n.cancelFailed,
      'forgot_password_failed' => l10n.forgotPasswordFailed,
      _ => key,
    };
  }
}
