import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../deals/domain/entities/deal.dart';
import '../../../deals/presentation/widgets/deal_card.dart';
import '../../../services/domain/entities/service.dart';
import '../../../services/presentation/widgets/service_tile.dart';
import '../../../reviews/presentation/widgets/reviews_preview_section.dart';
import '../../domain/entities/salon.dart';
import '../cubit/salon_detail_cubit.dart';

class SalonDetailPage extends StatelessWidget {
  const SalonDetailPage({super.key, required this.salonId});

  final String salonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalonDetailCubit>()..load(salonId),
      child: SalonDetailView(salonId: salonId),
    );
  }
}

class SalonDetailView extends StatelessWidget {
  const SalonDetailView({super.key, required this.salonId});

  final String salonId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocBuilder<SalonDetailCubit, SalonDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: switch (state) {
            SalonDetailLoading() => const AppLoadingIndicator(),
            SalonDetailFailure(:final message) => AppErrorWidget(
                message: ValidationMessages.resolveError(context, message),
                onRetry: () =>
                    context.read<SalonDetailCubit>().load(salonId),
              ),
            SalonDetailLoaded(:final salon, :final services, :final deals) =>
              SalonDetailContent(
                salon: salon,
                services: services,
                deals: deals,
                l10n: l10n,
              ),
          },
          bottomNavigationBar: state is SalonDetailLoaded
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SalonButton(
                      fullWidth: true,
                      onPressed: () => GuestGuard.runIfAllowed(
                        context,
                        () => context.push(
                          '${RouteNames.booking}?salonId=$salonId',
                        ),
                      ),
                      child: Text(l10n.bookNow),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class SalonDetailContent extends StatelessWidget {
  const SalonDetailContent({
    super.key,
    required this.salon,
    required this.services,
    required this.deals,
    required this.l10n,
  });

  final Salon salon;
  final List<Service> services;
  final List<Deal> deals;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.foreground,
          flexibleSpace: FlexibleSpaceBar(
            background: AppNetworkImage(
              imageUrl: salon.imageUrl,
              height: 220,
              borderRadius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon.name,
                  style: theme.textTheme.h2.copyWith(
                    color: theme.colorScheme.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (salon.rating != null)
                      RatingBadge(rating: salon.rating!),
                    if (salon.distance != null) ...[
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.mapPin,
                        size: 16,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(AppFormatters.distance(salon.distance)),
                    ],
                  ],
                ),
                if (salon.address != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    salon.address!,
                    style: theme.textTheme.muted,
                  ),
                ],
                if (salon.description != null) ...[
                  const SizedBox(height: 16),
                  Text(salon.description!, style: theme.textTheme.p),
                ],
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SectionHeader(title: l10n.services)),
        if (services.isEmpty)
          SliverToBoxAdapter(
            child: AppEmptyState(
              message: l10n.noServices,
              icon: LucideIcons.scissors,
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ServiceTile(
                  service: services[index],
                  onTap: () => GuestGuard.runIfAllowed(
                    context,
                    () => context.push(
                      '${RouteNames.booking}?salonId=${salon.id}&serviceId=${services[index].id}',
                    ),
                  ),
                  trailing: ShadButton.ghost(
                    onPressed: () => GuestGuard.runIfAllowed(
                      context,
                      () => context.push(
                        '${RouteNames.booking}?salonId=${salon.id}&serviceId=${services[index].id}',
                      ),
                    ),
                    child: Icon(
                      LucideIcons.calendar,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              childCount: services.length,
            ),
          ),
        SliverToBoxAdapter(child: SectionHeader(title: l10n.deals)),
        if (deals.isEmpty)
          SliverToBoxAdapter(
            child: AppEmptyState(
              message: l10n.noDeals,
              icon: LucideIcons.tag,
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DealCard(deal: deals[index], onTap: () {}),
              ),
              childCount: deals.length,
            ),
          ),
        SliverToBoxAdapter(
          child: ReviewsPreviewSection(
            salonId: salon.id,
            salonName: salon.name,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
