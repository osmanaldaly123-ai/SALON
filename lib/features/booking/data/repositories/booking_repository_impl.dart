import '../../domain/entities/booking.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._remote);

  final BookingRemoteDataSource _remote;

  @override
  Future<Booking> createBooking({
    required String salonId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  }) =>
      _remote.createBooking(
        salonId: salonId,
        serviceId: serviceId,
        dateTime: dateTime,
        notes: notes,
      );

  @override
  Future<List<TimeSlot>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
  }) =>
      _remote.getAvailableSlots(
        salonId: salonId,
        serviceId: serviceId,
        date: date,
      );

  @override
  Future<void> cancelBooking(String bookingId) =>
      _remote.cancelBooking(bookingId);
}
