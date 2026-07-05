import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../domain/entities/booking_draft.dart';

class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({
    super.key,
    required this.currentStep,
  });

  final BookingStep currentStep;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final steps = BookingStep.values;
    final currentIndex = currentStep.index;

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.border,
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final isActive = stepIndex == currentIndex;
        final isCompleted = stepIndex < currentIndex;

        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.border,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? Icon(
                  LucideIcons.check,
                  size: 16,
                  color: theme.colorScheme.primaryForeground,
                )
              : Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    color: isActive
                        ? theme.colorScheme.primaryForeground
                        : theme.colorScheme.mutedForeground,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
        );
      }),
    );
  }
}
