import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../salons/domain/entities/salon.dart';
import '../../../salons/domain/repositories/salons_repository.dart';
import '../../../services/domain/entities/service.dart';
import '../../../services/domain/repositories/services_repository.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/booking_repository.dart';

sealed class BookingFlowState extends Equatable {
  const BookingFlowState();

  @override
  List<Object?> get props => [];
}

final class BookingFlowLoading extends BookingFlowState {
  const BookingFlowLoading();
}

final class BookingFlowActive extends BookingFlowState {
  const BookingFlowActive({
    required this.draft,
    required this.step,
    this.salon,
    this.services = const [],
    this.slots = const [],
    this.loadingSlots = false,
    this.slotsError,
  });

  final BookingDraft draft;
  final BookingStep step;
  final Salon? salon;
  final List<Service> services;
  final List<TimeSlot> slots;
  final bool loadingSlots;
  final String? slotsError;

  BookingFlowActive copyWith({
    BookingDraft? draft,
    BookingStep? step,
    Salon? salon,
    List<Service>? services,
    List<TimeSlot>? slots,
    bool? loadingSlots,
    String? slotsError,
    bool clearSlotsError = false,
  }) {
    return BookingFlowActive(
      draft: draft ?? this.draft,
      step: step ?? this.step,
      salon: salon ?? this.salon,
      services: services ?? this.services,
      slots: slots ?? this.slots,
      loadingSlots: loadingSlots ?? this.loadingSlots,
      slotsError: clearSlotsError ? null : (slotsError ?? this.slotsError),
    );
  }

  @override
  List<Object?> get props =>
      [draft, step, salon, services, slots, loadingSlots, slotsError];
}

final class BookingFlowSubmitting extends BookingFlowState {
  const BookingFlowSubmitting(this.draft);

  final BookingDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class BookingFlowSuccess extends BookingFlowState {
  const BookingFlowSuccess(this.booking);

  final Booking booking;

  @override
  List<Object?> get props => [booking];
}

final class BookingFlowFailure extends BookingFlowState {
  const BookingFlowFailure(this.message, {this.previous});

  final String message;
  final BookingFlowActive? previous;

  @override
  List<Object?> get props => [message, previous];
}

class BookingFlowCubit extends Cubit<BookingFlowState> {
  BookingFlowCubit(
    this._bookingRepository,
    this._salonsRepository,
    this._servicesRepository,
  ) : super(const BookingFlowLoading());

  final BookingRepository _bookingRepository;
  final SalonsRepository _salonsRepository;
  final ServicesRepository _servicesRepository;

  Future<void> initialize({
    String? salonId,
    String? serviceId,
    String? salonName,
    String? serviceName,
  }) async {
    emit(const BookingFlowLoading());
    try {
      Salon? salon;
      var draft = BookingDraft(
        salonId: salonId,
        salonName: salonName,
        serviceId: serviceId,
        serviceName: serviceName,
      );

      List<Service> services = [];
      if (salonId != null && salonId.isNotEmpty) {
        final results = await Future.wait([
          _salonsRepository.getSalonById(salonId),
          _servicesRepository.getServices(salonId: salonId),
        ]);
        salon = results[0] as Salon;
        services = results[1] as List<Service>;
        draft = draft.copyWith(
          salonName: salon.name,
        );

        if (serviceId != null && serviceId.isNotEmpty) {
          Service? matched;
          for (final s in services) {
            if (s.id == serviceId) {
              matched = s;
              break;
            }
          }
          if (matched != null) {
            draft = draft.copyWith(
              serviceName: matched.name,
              price: matched.price,
            );
          }
        }
      }

      final initialStep = draft.hasService
          ? BookingStep.dateTime
          : draft.hasSalon
              ? BookingStep.service
              : BookingStep.service;

      emit(BookingFlowActive(
        draft: draft,
        step: initialStep,
        salon: salon,
        services: services,
      ));

      if (draft.hasService && draft.hasSalon && draft.date != null) {
        await _loadSlots();
      }
    } on ServerException catch (e) {
      emit(BookingFlowFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const BookingFlowFailure('load_failed'));
    }
  }

  void selectService(Service service) {
    final current = _active;
    if (current == null) return;

    emit(current.copyWith(
      draft: current.draft.copyWith(
        serviceId: service.id,
        serviceName: service.name,
        price: service.price,
        clearSlot: true,
        clearDate: true,
      ),
      step: BookingStep.dateTime,
      slots: [],
      clearSlotsError: true,
    ));
  }

  Future<void> selectDate(DateTime date) async {
    final current = _active;
    if (current == null || !current.draft.hasService) return;

    final normalized = DateTime(date.year, date.month, date.day);
    emit(current.copyWith(
      draft: current.draft.copyWith(
        date: normalized,
        clearSlot: true,
      ),
      slots: [],
      loadingSlots: true,
      clearSlotsError: true,
    ));

    await _loadSlots();
  }

  Future<void> _loadSlots() async {
    final current = _active;
    if (current == null) return;

    final draft = current.draft;
    if (!draft.hasSalon || !draft.hasService || draft.date == null) return;

    emit(current.copyWith(loadingSlots: true, clearSlotsError: true));

    try {
      final slots = await _bookingRepository.getAvailableSlots(
        salonId: draft.salonId!,
        serviceId: draft.serviceId!,
        date: draft.date!,
      );
      final updated = _active;
      if (updated == null) return;
      emit(updated.copyWith(
        slots: slots,
        loadingSlots: false,
        clearSlotsError: true,
      ));
    } on ServerException catch (e) {
      final updated = _active;
      if (updated == null) return;
      emit(updated.copyWith(
        loadingSlots: false,
        slotsError: e.message ?? 'load_failed',
      ));
    } catch (_) {
      final updated = _active;
      if (updated == null) return;
      emit(updated.copyWith(
        loadingSlots: false,
        slotsError: 'load_failed',
      ));
    }
  }

  void selectSlot(DateTime slot) {
    final current = _active;
    if (current == null) return;

    emit(current.copyWith(
      draft: current.draft.copyWith(slot: slot),
    ));
  }

  void setNotes(String notes) {
    final current = _active;
    if (current == null) return;
    emit(current.copyWith(draft: current.draft.copyWith(notes: notes)));
  }

  void goToStep(BookingStep step) {
    final current = _active;
    if (current == null) return;
    emit(current.copyWith(step: step));
  }

  void goNext() {
    final current = _active;
    if (current == null) return;

    switch (current.step) {
      case BookingStep.service:
        if (current.draft.hasService) {
          emit(current.copyWith(step: BookingStep.dateTime));
        }
      case BookingStep.dateTime:
        if (current.draft.hasSlot) {
          emit(current.copyWith(step: BookingStep.summary));
        }
      case BookingStep.summary:
        break;
    }
  }

  void goBack() {
    final current = _active;
    if (current == null) return;

    switch (current.step) {
      case BookingStep.service:
        break;
      case BookingStep.dateTime:
        emit(current.copyWith(step: BookingStep.service));
      case BookingStep.summary:
        emit(current.copyWith(step: BookingStep.dateTime));
    }
  }

  Future<void> submit() async {
    final current = _active;
    if (current == null) return;

    final draft = current.draft;
    if (!draft.hasSalon ||
        !draft.hasService ||
        draft.slot == null) {
      return;
    }

    emit(BookingFlowSubmitting(draft));

    try {
      final booking = await _bookingRepository.createBooking(
        salonId: draft.salonId!,
        serviceId: draft.serviceId!,
        dateTime: draft.slot!,
        notes: draft.notes,
      );
      emit(BookingFlowSuccess(booking));
    } on ServerException catch (e) {
      emit(BookingFlowFailure(
        e.message ?? 'booking_failed',
        previous: current,
      ));
    } catch (_) {
      emit(BookingFlowFailure('booking_failed', previous: current));
    }
  }

  BookingFlowActive? get _active =>
      state is BookingFlowActive ? state as BookingFlowActive : null;

  void restoreFromFailure(BookingFlowActive previous) {
    emit(previous);
  }
}
