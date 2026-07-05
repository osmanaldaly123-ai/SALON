import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/reviews_cubit.dart';
import '../widgets/star_rating.dart';

class SubmitReviewSheet extends StatefulWidget {
  const SubmitReviewSheet({
    super.key,
    required this.salonId,
    required this.salonName,
  });

  final String salonId;
  final String salonName;

  @override
  State<SubmitReviewSheet> createState() => _SubmitReviewSheetState();
}

class _SubmitReviewSheetState extends State<SubmitReviewSheet> {
  final _commentController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) return;

    context.read<ReviewsCubit>().submit(
          salonId: widget.salonId,
          rating: _rating,
          comment: _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocListener<ReviewsCubit, ReviewsState>(
      listenWhen: (prev, curr) =>
          curr is ReviewsLoaded && prev is ReviewsSubmitting,
      listener: (context, state) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.reviewSubmitted)),
        );
      },
      child: BlocListener<ReviewsCubit, ReviewsState>(
        listenWhen: (prev, curr) => curr is ReviewsFailure,
        listener: (context, state) {
          if (state is ReviewsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ValidationMessages.resolveError(context, state.message),
                ),
                backgroundColor: theme.colorScheme.destructive,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.writeReview, style: theme.textTheme.h3),
              const SizedBox(height: 4),
              Text(widget.salonName, style: theme.textTheme.muted),
              const SizedBox(height: 24),
              Text(
                l10n.yourRating,
                textAlign: TextAlign.center,
                style: theme.textTheme.p,
              ),
              StarRatingInput(
                rating: _rating,
                onChanged: (value) => setState(() => _rating = value),
              ),
              const SizedBox(height: 16),
              ShadTextarea(
                controller: _commentController,
                placeholder: Text(l10n.reviewCommentHint),
                minHeight: 120,
                maxHeight: 160,
              ),
              const SizedBox(height: 24),
              BlocBuilder<ReviewsCubit, ReviewsState>(
                builder: (context, state) {
                  final isSubmitting = state is ReviewsSubmitting;

                  return SalonButton(
                    fullWidth: true,
                    onPressed: _rating > 0 && !isSubmitting ? _submit : null,
                    isLoading: isSubmitting,
                    child: Text(l10n.submitReview),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
