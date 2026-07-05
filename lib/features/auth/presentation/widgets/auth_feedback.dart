import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/validation_messages.dart';

void showAuthFeedback(BuildContext context, String messageKey) {
  final message = ValidationMessages.resolveError(context, messageKey);
  ShadSonner.of(context).show(
    ShadToast.destructive(
      title: Text(message),
    ),
  );
}

Widget? buildAuthErrorAlert(BuildContext context, String? messageKey) {
  if (messageKey == null) return null;

  final message = ValidationMessages.resolveError(context, messageKey);
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: ShadAlert.destructive(
      title: Text(message),
    ),
  );
}
