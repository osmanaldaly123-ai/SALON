import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/deals_cubit.dart';
import '../widgets/deal_card.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key, this.salonId});

  final String? salonId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocProvider(
      create: (_) => sl<DealsCubit>()..load(salonId: salonId),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.foreground,
          title: Text(l10n.deals),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<DealsCubit, DealsState>(
          builder: (context, state) {
            final cubit = context.read<DealsCubit>();

            return switch (state) {
              DealsLoading() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (_, __) => const ShimmerBox(
                    height: 180,
                    borderRadius: 16,
                  ),
                ),
              DealsFailure(:final message) => AppErrorWidget(
                  message: ValidationMessages.resolveError(context, message),
                  onRetry: cubit.refresh,
                ),
              DealsLoaded(:final deals) => deals.isEmpty
                  ? AppEmptyState(
                      message: l10n.noDeals,
                      icon: LucideIcons.tag,
                    )
                  : RefreshIndicator(
                      color: theme.colorScheme.primary,
                      onRefresh: cubit.refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: deals.length,
                        itemBuilder: (context, index) {
                          final deal = deals[index];
                          return DealCard(
                            deal: deal,
                            onTap: () {
                              if (deal.salonId != null) {
                                context.push('/salons/${deal.salonId}');
                              }
                            },
                          );
                        },
                      ),
                    ),
            };
          },
        ),
      ),
    );
  }
}