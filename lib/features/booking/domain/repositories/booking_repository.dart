import '../entities/booking.dart';
import '../entities/time_slot.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String salonId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  });
  Future<List<TimeSlot>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
  });
  Future<void> cancelBooking(String bookingId);
}
