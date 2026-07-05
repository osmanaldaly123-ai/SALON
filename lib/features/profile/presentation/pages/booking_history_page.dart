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
import '../../../booking/domain/entities/booking_extensions.dart';
import '../../../booking/domain/entities/booking.dart';
import '../cubit/booking_history_cubit.dart';
import '../widgets/booking_history_tile.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final _tabController = ShadTabsController<String>(value: 'upcoming');

  Future<void> _confirmCancel(
    BuildContext context,
    String bookingId,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showShadDialog<bool>(
      context: context,
      builder: (ctx) => ShadDialog.alert(
        title: Text(l10n.cancelBooking),
        description: Text(l10n.cancelBookingConfirm),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.back),
          ),
          ShadButton.destructive(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<BookingHistoryCubit>().cancelBooking(bookingId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocProvider(
      create: (_) => sl<BookingHistoryCubit>()..load(),
      child: BlocConsumer<BookingHistoryCubit, BookingHistoryState>(
        listenWhen: (prev, curr) => curr is BookingHistoryFailure,
        listener: (context, state) {
          if (state is BookingHistoryFailure) {
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
          return Scaffold(
            backgroundColor: theme.colorScheme.background,
            appBar: AppBar(
              backgroundColor: theme.colorScheme.background,
              foregroundColor: theme.colorScheme.foreground,
              title: Text(l10n.myAppointments),
              centerTitle: true,
              automaticallyImplyLeading: widget.showBackButton,
              leading: widget.showBackButton
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => context.pop(),
                    )
                  : null,
            ),
            body: switch (state) {
              BookingHistoryLoading() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (_, _) => const ListTileShimmer(),
                ),
              BookingHistoryFailure(:final message) => AppErrorWidget(
                  message:
                      ValidationMessages.resolveError(context, message),
                  onRetry: () =>
                      context.read<BookingHistoryCubit>().load(),
                ),
              BookingHistoryLoaded(:final upcoming, :final past,
                  :final cancellingId) =>
                ShadTabs<String>(
                  controller: _tabController,
                  tabs: [
                    ShadTab(
                      value: 'upcoming',
                      content: _BookingList(
                        bookings: upcoming,
                        emptyMessage: l10n.noUpcomingBookings,
                        cancellingId: cancellingId,
                        onCancel: (id) => _confirmCancel(context, id, l10n),
                        onRefresh: () =>
                            context.read<BookingHistoryCubit>().refresh(),
                      ),
                      child: Text(l10n.upcomingBookings),
                    ),
                    ShadTab(
                      value: 'past',
                      content: _BookingList(
                        bookings: past,
                        emptyMessage: l10n.noPastBookings,
                        onRefresh: () =>
                            context.read<BookingHistoryCubit>().refresh(),
                      ),
                      child: Text(l10n.pastBookings),
                    ),
                  ],
                ),
            },
          );
        },
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.bookings,
    required this.emptyMessage,
    required this.onRefresh,
    this.cancellingId,
    this.onCancel,
  });

  final List<Booking> bookings;
  final String emptyMessage;
  final Future<void> Function() onRefresh;
  final String? cancellingId;
  final void Function(String id)? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (bookings.isEmpty) {
      return AppEmptyState(
        message: emptyMessage,
        icon: LucideIcons.calendar,
      );
    }

    return RefreshIndicator(
      color: theme.colorScheme.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingHistoryTile(
            booking: booking,
            isCancelling: cancellingId == booking.id,
            onCancel: booking.canCancel && onCancel != null
                ? () => onCancel!(booking.id)
                : null,
          );
        },
      ),
    );
  }
}
