import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../booking/domain/entities/booking_extensions.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../domain/repositories/profile_repository.dart';

sealed class BookingHistoryState extends Equatable {
  const BookingHistoryState();

  @override
  List<Object?> get props => [];
}

final class BookingHistoryLoading extends BookingHistoryState {
  const BookingHistoryLoading();
}

final class BookingHistoryLoaded extends BookingHistoryState {
  const BookingHistoryLoaded({
    required this.upcoming,
    required this.past,
    this.cancellingId,
  });

  final List<Booking> upcoming;
  final List<Booking> past;
  final String? cancellingId;

  @override
  List<Object?> get props => [upcoming, past, cancellingId];
}

final class BookingHistoryFailure extends BookingHistoryState {
  const BookingHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  BookingHistoryCubit(this._profileRepository, this._bookingRepository)
      : super(const BookingHistoryLoading());

  final ProfileRepository _profileRepository;
  final BookingRepository _bookingRepository;

  List<Booking> _all = [];

  Future<void> load() async {
    emit(const BookingHistoryLoading());
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<void> cancelBooking(String bookingId) async {
    final current = state;
    if (current is! BookingHistoryLoaded) return;

    emit(BookingHistoryLoaded(
      upcoming: current.upcoming,
      past: current.past,
      cancellingId: bookingId,
    ));

    try {
      await _bookingRepository.cancelBooking(bookingId);
      await _fetch();
    } on ServerException catch (e) {
      emit(BookingHistoryFailure(e.message ?? 'cancel_failed'));
      emit(_splitBookings(_all));
    } catch (_) {
      emit(const BookingHistoryFailure('cancel_failed'));
      emit(_splitBookings(_all));
    }
  }

  Future<void> _fetch() async {
    try {
      _all = await _profileRepository.getBookingHistory();
      _all.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      emit(_splitBookings(_all));
    } on ServerException catch (e) {
      emit(BookingHistoryFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const BookingHistoryFailure('load_failed'));
    }
  }

  BookingHistoryLoaded _splitBookings(List<Booking> bookings) {
    final upcoming = bookings.where((b) => b.isUpcoming).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final past = bookings.where((b) => !b.isUpcoming).toList();
    return BookingHistoryLoaded(upcoming: upcoming, past: past);
  }
}
