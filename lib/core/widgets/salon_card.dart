import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Generic [ShadCard] wrapper for list items and content blocks.
class SalonListCard extends StatelessWidget {
  const SalonListCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.leading,
    this.trailing,
    this.title,
    this.description,
    this.footer,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? description;
  final Widget? footer;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final card = ShadCard(
      padding: padding ?? const EdgeInsets.all(16),
      leading: leading,
      trailing: trailing,
      title: title,
      description: description,
      footer: footer,
      child: child,
    );

    final wrapped = onTap != null
        ? GestureDetector(onTap: onTap, child: card)
        : card;

    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: 12),
      child: wrapped,
    );
  }
}
