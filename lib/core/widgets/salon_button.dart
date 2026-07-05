import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum SalonButtonVariant { primary, outline, destructive, ghost, link }

class SalonButton extends StatelessWidget {
  const SalonButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = SalonButtonVariant.primary,
    this.size,
    this.fullWidth = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final SalonButtonVariant variant;
  final ShadButtonSize? size;
  final bool fullWidth;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? (fullWidth ? ShadButtonSize.lg : null);
    final width = fullWidth ? double.infinity : null;
    final enabled = !isLoading && onPressed != null;

    final content = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == SalonButtonVariant.outline ||
                      variant == SalonButtonVariant.ghost ||
                      variant == SalonButtonVariant.link
                  ? ShadTheme.of(context).colorScheme.primary
                  : ShadTheme.of(context).colorScheme.primaryForeground,
            ),
          )
        : child;

    final button = switch (variant) {
      SalonButtonVariant.primary => ShadButton(
          onPressed: enabled ? onPressed : null,
          size: effectiveSize,
          width: width,
          leading: leading,
          trailing: trailing,
          child: content,
        ),
      SalonButtonVariant.outline => ShadButton.outline(
          onPressed: enabled ? onPressed : null,
          size: effectiveSize,
          width: width,
          leading: leading,
          trailing: trailing,
          child: content,
        ),
      SalonButtonVariant.destructive => ShadButton.destructive(
          onPressed: enabled ? onPressed : null,
          size: effectiveSize,
          width: width,
          leading: leading,
          trailing: trailing,
          child: content,
        ),
      SalonButtonVariant.ghost => ShadButton.ghost(
          onPressed: enabled ? onPressed : null,
          size: effectiveSize,
          width: width,
          leading: leading,
          trailing: trailing,
          child: content,
        ),
      SalonButtonVariant.link => ShadButton.link(
          onPressed: enabled ? onPressed : null,
          size: effectiveSize,
          width: width,
          leading: leading,
          trailing: trailing,
          child: content,
        ),
    };

    return button;
  }
}
