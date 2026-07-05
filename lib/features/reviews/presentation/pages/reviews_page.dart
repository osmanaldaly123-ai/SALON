import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/reviews_cubit.dart';
import '../widgets/review_tile.dart';
import '../widgets/reviews_summary_header.dart';
import '../widgets/submit_review_sheet.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({
    super.key,
    required this.salonId,
    this.salonName,
  });

  final String salonId;
  final String? salonName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) {
        if (salonId.isEmpty) return sl<ReviewsCubit>();
        return sl<ReviewsCubit>()..load(salonId);
      },
      child: salonId.isEmpty
          ? _NoSalonView(l10n: l10n)
          : _ReviewsBody(
              salonId: salonId,
              salonName: salonName,
              l10n: l10n,
            ),
    );
  }
}

class _NoSalonView extends StatelessWidget {
  const _NoSalonView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        title: Text(l10n.reviews),
      ),
      body: AppEmptyState(
        message: l10n.selectSalonFirst,
        icon: LucideIcons.store,
      ),
    );
  }
}

class _ReviewsBody extends StatelessWidget {
  const _ReviewsBody({
    required this.salonId,
    required this.salonName,
    required this.l10n,
  });

  final String salonId;
  final String? salonName;
  final AppLocalizations l10n;

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
        child: SubmitReviewSheet(
          salonId: salonId,
          salonName: salonName ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        title: Text(l10n.reviews),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: ShadButton(
        onPressed: () => GuestGuard.runIfAllowed(
          context,
          () => _openSubmitSheet(context),
        ),
        leading: const Icon(LucideIcons.penLine, size: 18),
        child: Text(l10n.writeReview),
      ),
      body: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          final cubit = context.read<ReviewsCubit>();

          return switch (state) {
            ReviewsLoading() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (_, __) => const ListTileShimmer(),
              ),
            ReviewsFailure(:final message) => AppErrorWidget(
                message: ValidationMessages.resolveError(context, message),
                onRetry: cubit.refresh,
              ),
            ReviewsLoaded(:final reviews, :final averageRating) =>
              reviews.isEmpty
                  ? AppEmptyState(
                      message: l10n.noReviews,
                      icon: LucideIcons.star,
                    )
                  : RefreshIndicator(
                      color: theme.colorScheme.primary,
                      onRefresh: cubit.refresh,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          ReviewsSummaryHeader(
                            averageRating: averageRating,
                            reviewCount: reviews.length,
                          ),
                          const SizedBox(height: 16),
                          ...reviews.map((r) => ReviewTile(review: r)),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
            ReviewsSubmitting(:final reviews, :final averageRating) =>
              reviews.isEmpty
                  ? AppLoadingIndicator(message: l10n.submittingReview)
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ReviewsSummaryHeader(
                          averageRating: averageRating,
                          reviewCount: reviews.length,
                        ),
                        const SizedBox(height: 16),
                        ...reviews.map((r) => ReviewTile(review: r)),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
          };
        },
      ),
    );
  }
}
