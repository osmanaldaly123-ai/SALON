import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validation_messages.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/salon_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../services/presentation/widgets/service_tile.dart';
import '../../domain/entities/booking_draft.dart';
import '../cubit/booking_flow_cubit.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/time_slot_grid.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({
    super.key,
    this.salonId,
    this.serviceId,
    this.salonName,
    this.serviceName,
  });

  final String? salonId;
  final String? serviceId;
  final String? salonName;
  final String? serviceName;

  @override
  Widget build(BuildContext context) {
    if (sl<GuestSessionService>().isGuest) {
      return _GuestBookingBlockedView(
        onSignIn: () => context.go(RouteNames.login),
      );
    }

    return BlocProvider(
      create: (_) => sl<BookingFlowCubit>()
        ..initialize(
          salonId: salonId,
          serviceId: serviceId,
          salonName: salonName,
          serviceName: serviceName,
        ),
      child: const _BookingView(),
    );
  }
}

class _BookingView extends StatefulWidget {
  const _BookingView();

  @override
  State<_BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<_BookingView> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BookingFlowActive state) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.draft.date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null && mounted) {
      context.read<BookingFlowCubit>().selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return BlocConsumer<BookingFlowCubit, BookingFlowState>(
      listenWhen: (prev, curr) =>
          curr is BookingFlowSuccess || curr is BookingFlowFailure,
      listener: (context, state) {
        if (state is BookingFlowSuccess) {
          context.go(RouteNames.bookingSuccess, extra: state.booking);
        } else if (state is BookingFlowFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  ValidationMessages.resolveError(context, state.message),
                ),
                backgroundColor: theme.colorScheme.destructive,
              ),
            );
          if (state.previous != null) {
            context.read<BookingFlowCubit>().restoreFromFailure(state.previous!);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            foregroundColor: theme.colorScheme.foreground,
            title: Text(l10n.booking),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () {
                if (state is BookingFlowActive && state.step != BookingStep.service) {
                  context.read<BookingFlowCubit>().goBack();
                } else {
                  context.pop();
                }
              },
            ),
          ),
          body: switch (state) {
            BookingFlowLoading() => AppLoadingIndicator(message: l10n.loading),
            BookingFlowFailure(:final message, previous: null) => AppErrorWidget(
                message: ValidationMessages.resolveError(context, message),
                onRetry: () => context.pop(),
              ),
            BookingFlowFailure() => const SizedBox.shrink(),
            BookingFlowSubmitting() => AppLoadingIndicator(
                message: l10n.confirmingBooking,
              ),
            BookingFlowActive() => _buildActive(context, state, l10n),
            BookingFlowSuccess() => const SizedBox.shrink(),
          },
          bottomNavigationBar: state is BookingFlowActive
              ? _buildBottomBar(context, state, l10n)
              : null,
        );
      },
    );
  }

  Widget _buildActive(
    BuildContext context,
    BookingFlowActive state,
    AppLocalizations l10n,
  ) {
    final theme = ShadTheme.of(context);

    if (!state.draft.hasSalon) {
      return AppEmptyState(
        message: l10n.selectSalonFirst,
        icon: LucideIcons.store,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BookingStepIndicator(currentStep: state.step),
          const SizedBox(height: 24),
          if (state.salon != null) ...[
            Text(
              state.salon!.name,
              style: theme.textTheme.h3,
            ),
            const SizedBox(height: 16),
          ],
          switch (state.step) {
            BookingStep.service => _ServiceStep(state: state, l10n: l10n),
            BookingStep.dateTime => _DateTimeStep(
                state: state,
                l10n: l10n,
                onPickDate: () => _pickDate(state),
              ),
            BookingStep.summary => _SummaryStep(
                state: state,
                l10n: l10n,
                notesController: _notesController,
              ),
          },
        ],
      ),
    );
  }

  Widget? _buildBottomBar(
    BuildContext context,
    BookingFlowActive state,
    AppLocalizations l10n,
  ) {
    if (!state.draft.hasSalon) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SalonButton(
            fullWidth: true,
            onPressed: () => context.go(RouteNames.salons),
            child: Text(l10n.browseSalons),
          ),
        ),
      );
    }

    final cubit = context.read<BookingFlowCubit>();
    final canProceed = switch (state.step) {
      BookingStep.service => state.draft.hasService,
      BookingStep.dateTime => state.draft.hasSlot,
      BookingStep.summary => state.draft.hasSlot,
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (state.step != BookingStep.service)
              Expanded(
                child: SalonButton(
                  variant: SalonButtonVariant.outline,
                  onPressed: cubit.goBack,
                  child: Text(l10n.back),
                ),
              ),
            if (state.step != BookingStep.service) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SalonButton(
                fullWidth: true,
                onPressed: canProceed
                    ? () {
                        if (state.step == BookingStep.summary) {
                          cubit.submit();
                        } else {
                          cubit.goNext();
                        }
                      }
                    : null,
                child: Text(
                  state.step == BookingStep.summary
                      ? l10n.confirmBooking
                      : l10n.next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceStep extends StatelessWidget {
  const _ServiceStep({required this.state, required this.l10n});

  final BookingFlowActive state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (state.services.isEmpty) {
      return AppEmptyState(
        message: l10n.noServices,
        icon: LucideIcons.scissors,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.selectService, style: theme.textTheme.p),
        const SizedBox(height: 12),
        ...state.services.map((service) {
          final isSelected = state.draft.serviceId == service.id;
          return ServiceTile(
            service: service,
            onTap: () => context.read<BookingFlowCubit>().selectService(service),
            trailing: isSelected
                ? Icon(LucideIcons.circleCheck, color: theme.colorScheme.primary)
                : null,
          );
        }),
      ],
    );
  }
}

class _DateTimeStep extends StatelessWidget {
  const _DateTimeStep({
    required this.state,
    required this.l10n,
    required this.onPickDate,
  });

  final BookingFlowActive state;
  final AppLocalizations l10n;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final dateLabel = state.draft.date != null
        ? DateFormat.yMMMd().format(state.draft.date!)
        : l10n.selectDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.selectDateTime, style: theme.textTheme.p),
        const SizedBox(height: 12),
        SalonButton(
          variant: SalonButtonVariant.outline,
          onPressed: onPickDate,
          leading: const Icon(LucideIcons.calendar, size: 18),
          child: Text(dateLabel),
        ),
        const SizedBox(height: 20),
        if (state.draft.date != null) ...[
          Text(l10n.availableSlots, style: theme.textTheme.muted),
          const SizedBox(height: 12),
          if (state.loadingSlots)
            Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          else if (state.slotsError != null)
            Text(
              ValidationMessages.resolveError(context, state.slotsError!),
              style: TextStyle(color: theme.colorScheme.destructive),
            )
          else if (state.slots.isEmpty)
            AppEmptyState(
              message: l10n.noSlotsAvailable,
              icon: LucideIcons.clock,
            )
          else
            TimeSlotGrid(
              slots: state.slots.map((s) => s.dateTime).toList(),
              selected: state.draft.slot,
              onSelected: context.read<BookingFlowCubit>().selectSlot,
            ),
        ],
      ],
    );
  }
}

class _SummaryStep extends StatelessWidget {
  const _SummaryStep({
    required this.state,
    required this.l10n,
    required this.notesController,
  });

  final BookingFlowActive state;
  final AppLocalizations l10n;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.bookingSummary, style: theme.textTheme.p),
        const SizedBox(height: 12),
        BookingSummaryCard(draft: state.draft),
        const SizedBox(height: 20),
        Text(l10n.notesOptional, style: theme.textTheme.muted),
        const SizedBox(height: 8),
        ShadTextarea(
          controller: notesController,
          placeholder: Text(l10n.notesHint),
          minHeight: 96,
          maxHeight: 120,
          onChanged: context.read<BookingFlowCubit>().setNotes,
        ),
      ],
    );
  }
}

class _GuestBookingBlockedView extends StatelessWidget {
  const _GuestBookingBlockedView({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        title: Text(l10n.booking),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.lock,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.guestActionBlocked,
                style: theme.textTheme.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.signInToContinue,
                style: theme.textTheme.muted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SalonButton(
                fullWidth: true,
                onPressed: onSignIn,
                child: Text(l10n.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
