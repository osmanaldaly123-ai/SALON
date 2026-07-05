import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/booking_model.dart';
import '../models/time_slot_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking({
    required String salonId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  });
  Future<List<TimeSlotModel>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
  });
  Future<void> cancelBooking(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<BookingModel> createBooking({
    required String salonId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  }) async {
    final response = await _client.post(
      ApiConstants.bookings,
      data: {
        'salon_id': salonId,
        'service_id': serviceId,
        'date_time': dateTime.toIso8601String(),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return BookingModel.fromJson(data);
  }

  @override
  Future<List<TimeSlotModel>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
  }) async {
    final response = await _client.get(
      '${ApiConstants.bookings}/slots',
      queryParameters: {
        'salon_id': salonId,
        'service_id': serviceId,
        'date': date.toIso8601String().split('T').first,
      },
    );
    final list = response.data['data'] as List<dynamic>? ??
        response.data['slots'] as List<dynamic>? ??
        response.data as List;
    return list
        .map(
          (e) => TimeSlotModel.fromJson(
            e as Map<String, dynamic>,
            date: date,
          ),
        )
        .where((slot) => slot.available)
        .toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _client.post(ApiConstants.bookingById(bookingId) + '/cancel');
  }
}
