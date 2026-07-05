import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../utils/validation_messages.dart';

class SalonTextField extends StatelessWidget {
  const SalonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.leading,
    this.trailing,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.autovalidateMode,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.small.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.foreground,
          ),
        ),
        const SizedBox(height: 8),
        FormField<String>(
          autovalidateMode: autovalidateMode,
          validator: (_) => ValidationMessages.resolve(
            context,
            validator?.call(controller.text),
          ),
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (maxLines > 1)
                  ShadTextarea(
                    controller: controller,
                    placeholder: hint != null ? Text(hint!) : null,
                    enabled: enabled && !readOnly,
                    readOnly: readOnly,
                    minHeight: maxLines * 28.0,
                    maxHeight: maxLines * 28.0,
                    onChanged: (value) {
                      field.didChange(value);
                      if (field.hasError) field.validate();
                    },
                  )
                else
                  ShadInput(
                    controller: controller,
                    placeholder: hint != null ? Text(hint!) : null,
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    obscureText: obscureText,
                    leading: leading,
                    trailing: trailing,
                    onSubmitted: onSubmitted,
                    enabled: enabled,
                    readOnly: readOnly,
                    onChanged: (value) {
                      field.didChange(value);
                      if (field.hasError) field.validate();
                    },
                  ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      field.errorText!,
                      style: theme.textTheme.muted.copyWith(
                        color: theme.colorScheme.destructive,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
