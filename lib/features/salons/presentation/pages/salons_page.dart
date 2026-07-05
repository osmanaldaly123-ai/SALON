import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/main_layout.dart';
import '../../../../core/widgets/salon_home_header.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/salons_bloc.dart';
import '../widgets/salon_card.dart';

class SalonsPage extends StatefulWidget {
  const SalonsPage({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  State<SalonsPage> createState() => _SalonsPageState();
}

class _SalonsPageState extends State<SalonsPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value, SalonsBloc bloc) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      bloc.add(SalonsSearchChanged(value.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocProvider(
      create: (_) => sl<SalonsBloc>()
        ..add(SalonsLoadRequested(query: widget.initialQuery)),
      child: MainLayout(
        currentIndex: MainTabIndex.salons,
        child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: Column(
            children: [
              SalonHomeHeader(title: l10n.salons, showLocation: false),
              Expanded(
                child: BlocBuilder<SalonsBloc, SalonsState>(
                  builder: (context, state) {
                    final bloc = context.read<SalonsBloc>();

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: ShadInput(
                            controller: _searchController,
                            onChanged: (v) => _onSearchChanged(v, bloc),
                            placeholder: Text(l10n.searchExtended),
                            leading: const Icon(LucideIcons.search, size: 18),
                          ),
                        ),
                        Expanded(
                          child: switch (state) {
                            SalonsInitial() || SalonsLoading() =>
                              ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: 6,
                                itemBuilder: (_, __) => const SalonCardShimmer(),
                              ),
                            SalonsFailure(:final message) => AppErrorWidget(
                                message: ValidationMessages.resolveError(
                                  context,
                                  message,
                                ),
                                onRetry: () =>
                                    bloc.add(const SalonsRefreshRequested()),
                              ),
                            SalonsLoaded(:final salons) => salons.isEmpty
                                ? AppEmptyState(
                                    message: l10n.noSalons,
                                    icon: LucideIcons.store,
                                  )
                                : RefreshIndicator(
                                    color: theme.colorScheme.primary,
                                    onRefresh: () async {
                                      bloc.add(const SalonsRefreshRequested());
                                      await bloc.stream.firstWhere(
                                        (s) =>
                                            s is SalonsLoaded ||
                                            s is SalonsFailure,
                                      );
                                    },
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: salons.length,
                                      itemBuilder: (context, index) {
                                        final salon = salons[index];
                                        return SalonCard(
                                          salon: salon,
                                          onTap: () =>
                                              context.push('/salons/${salon.id}'),
                                        );
                                      },
                                    ),
                                  ),
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
