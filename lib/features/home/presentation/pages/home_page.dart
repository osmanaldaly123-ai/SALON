import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/guest_banner.dart';
import '../../../../core/widgets/main_layout.dart';
import '../../../../core/widgets/salon_home_header.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../deals/presentation/widgets/deal_card.dart';
import '../../../salons/presentation/widgets/salon_card.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  bool _showGuestBanner = true;

  @override
  void initState() {
    super.initState();
    _loadGuestBannerPreference();
  }

  Future<void> _loadGuestBannerPreference() async {
    final prefs = sl<SharedPreferences>();
    final dismissed =
        prefs.getBool(AppConstants.guestBannerDismissedKey) ?? false;
    if (mounted) {
      setState(() => _showGuestBanner = !dismissed);
    }
  }

  Future<void> _dismissGuestBanner() async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool(AppConstants.guestBannerDismissedKey, true);
    if (mounted) {
      setState(() => _showGuestBanner = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.push('${RouteNames.salons}?q=${Uri.encodeComponent(query)}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocProvider(
      create: (_) => sl<HomeCubit>()..load(),
      child: MainLayout(
        currentIndex: MainTabIndex.home,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: theme.colorScheme.primary,
              onRefresh: () => context.read<HomeCubit>().load(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SalonHomeHeader()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_showGuestBanner)
                            GuestBanner(onDismiss: _dismissGuestBanner),
                          ShadInput(
                            controller: _searchController,
                            placeholder: Text(l10n.searchExtended),
                            textInputAction: TextInputAction.search,
                            leading: const Icon(LucideIcons.search, size: 18),
                            trailing: ShadButton.ghost(
                              onPressed: _search,
                              child: const Icon(LucideIcons.arrowRight, size: 18),
                            ),
                            onSubmitted: (_) => _search(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state is HomeLoading) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SalonCardShimmer(compact: true),
                      ),
                    ),
                  ] else if (state is HomeFailure) ...[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppErrorWidget(
                        message: ValidationMessages.resolveError(
                          context,
                          state.message,
                        ),
                        onRetry: () => context.read<HomeCubit>().load(),
                      ),
                    ),
                  ] else if (state is HomeLoaded) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: l10n.featuredSalons,
                        actionLabel: l10n.seeAll,
                        onAction: () => context.go(RouteNames.salons),
                      ),
                    ),
                    if (state.featuredSalons.isEmpty)
                      SliverToBoxAdapter(
                        child: AppEmptyState(
                          message: l10n.noSalons,
                          icon: LucideIcons.store,
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 170,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.featuredSalons.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final salon = state.featuredSalons[index];
                              return SalonCard(
                                compact: true,
                                salon: salon,
                                onTap: () => context.push(
                                  '/salons/${salon.id}',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: l10n.hotDeals,
                        actionLabel: l10n.seeAll,
                        onAction: () => context.push(RouteNames.deals),
                      ),
                    ),
                    if (state.deals.isEmpty)
                      SliverToBoxAdapter(
                        child: AppEmptyState(
                          message: l10n.noDeals,
                          icon: LucideIcons.tag,
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.deals.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final deal = state.deals[index];
                              return DealCard(
                                compact: true,
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
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 88),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
