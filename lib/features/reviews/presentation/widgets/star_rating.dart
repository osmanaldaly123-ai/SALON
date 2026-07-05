import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StarRatingDisplay extends StatelessWidget {
  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.size = 18,
    this.color,
  });

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? ShadTheme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final filled = rating >= starValue;
        final half = !filled && rating >= starValue - 0.5;

        return Icon(
          LucideIcons.star,
          size: size,
          color: filled || half
              ? effectiveColor
              : ShadTheme.of(context).colorScheme.border,
        );
      }),
    );
  }
}

class StarRatingInput extends StatelessWidget {
  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 36,
  });

  final double rating;
  final ValueChanged<double> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = (index + 1).toDouble();
        final filled = rating >= starValue;

        return ShadButton.ghost(
          onPressed: () => onChanged(starValue),
          child: Icon(
            LucideIcons.star,
            size: size,
            color: filled ? theme.colorScheme.primary : theme.colorScheme.border,
          ),
        );
      }),
    );
  }
}
