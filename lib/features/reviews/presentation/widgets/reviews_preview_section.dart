import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/reviews_cubit.dart';
import '../widgets/review_tile.dart';
import '../widgets/reviews_summary_header.dart';
import 'submit_review_sheet.dart';

class ReviewsPreviewSection extends StatelessWidget {
  const ReviewsPreviewSection({
    super.key,
    required this.salonId,
    required this.salonName,
  });

  final String salonId;
  final String salonName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewsCubit>()..load(salonId),
      child: _ReviewsPreviewContent(salonId: salonId, salonName: salonName),
    );
  }
}

class _ReviewsPreviewContent extends StatelessWidget {
  const _ReviewsPreviewContent({
    required this.salonId,
    required this.salonName,
  });

  final String salonId;
  final String salonName;

  void _openSubmitSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ReviewsCubit>(),
        child: SubmitReviewSheet(salonId: salonId, salonName: salonName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocConsumer<ReviewsCubit, ReviewsState>(
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
      builder: (context, state) {
        return Column(
          children: [
            SectionHeader(
              title: l10n.reviews,
              actionLabel: l10n.seeAll,
              onAction: () => context.push(
                '${RouteNames.reviews}?salonId=$salonId&salonName=${Uri.encodeComponent(salonName)}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: switch (state) {
                ReviewsLoading() => const Column(
                    children: [
                      ShimmerBox(height: 72, borderRadius: 16),
                      SizedBox(height: 8),
                      ListTileShimmer(),
                    ],
                  ),
                ReviewsLoaded(:final reviews, :final averageRating) =>
                  Column(
                    children: [
                      if (reviews.isNotEmpty)
                        ReviewsSummaryHeader(
                          averageRating: averageRating,
                          reviewCount: reviews.length,
                        ),
                      if (reviews.isEmpty)
                        AppEmptyState(
                          message: l10n.noReviews,
                          icon: LucideIcons.star,
                        )
                      else ...[
                        const SizedBox(height: 12),
                        ...reviews.take(3).map(
                              (review) => ReviewTile(review: review),
                            ),
                      ],
                      const SizedBox(height: 8),
                      ShadButton.outline(
                        onPressed: () => GuestGuard.runIfAllowed(
                          context,
                          () => _openSubmitSheet(context),
                        ),
                        leading: const Icon(LucideIcons.penLine, size: 18),
                        child: Text(l10n.writeReview),
                      ),
                    ],
                  ),
                ReviewsSubmitting(:final reviews, :final averageRating) =>
                  Column(
                    children: [
                      if (reviews.isNotEmpty)
                        ReviewsSummaryHeader(
                          averageRating: averageRating,
                          reviewCount: reviews.length,
                        ),
                      AppLoadingIndicator(message: l10n.submittingReview),
                    ],
                  ),
                ReviewsFailure() => AppEmptyState(
                    message: l10n.noReviews,
                    icon: LucideIcons.star,
                  ),
              },
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
