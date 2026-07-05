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
import '../cubit/services_cubit.dart';
import '../widgets/service_tile.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, this.salonId});

  final String? salonId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocProvider(
      create: (_) => sl<ServicesCubit>()..load(salonId: salonId),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.foreground,
          title: Text(l10n.services),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<ServicesCubit, ServicesState>(
          builder: (context, state) {
            final cubit = context.read<ServicesCubit>();

            return switch (state) {
              ServicesLoading() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  itemBuilder: (_, _) => const ListTileShimmer(),
                ),
              ServicesFailure(:final message) => AppErrorWidget(
                  message: ValidationMessages.resolveError(context, message),
                  onRetry: cubit.refresh,
                ),
              ServicesLoaded(:final services) => services.isEmpty
                  ? AppEmptyState(
                      message: l10n.noServices,
                      icon: LucideIcons.scissors,
                    )
                  : RefreshIndicator(
                      color: theme.colorScheme.primary,
                      onRefresh: cubit.refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return ServiceTile(service: services[index]);
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
