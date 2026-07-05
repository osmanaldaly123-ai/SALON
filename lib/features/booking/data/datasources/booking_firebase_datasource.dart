import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/firebase/firebase_auth_client.dart';
import '../../../../core/firebase/firebase_data_paths.dart';
import '../../../../core/firebase/realtime_database_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/booking_model.dart';
import '../models/time_slot_model.dart';
import 'booking_remote_datasource.dart';

class BookingFirebaseDataSource implements BookingRemoteDataSource {
  BookingFirebaseDataSource(this._auth, this._db);

  final FirebaseAuthClient _auth;
  final RealtimeDatabaseClient _db;

  static const _slotHours = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

  @override
  Future<BookingModel> createBooking({
    required String salonId,
    required String serviceId,
    required DateTime dateTime,
    String? notes,
  }) async {
    final user = _requireUser();
    final slotKey = _slotKey(salonId, serviceId, dateTime);

    final taken = await _db.ref('${FirebaseDataPaths.takenSlots}/$slotKey').get();
    if (taken.exists && taken.value == true) {
      throw const ServerException(message: 'booking_failed');
    }

    final salon = await _db.getChild(FirebaseDataPaths.salons, salonId);
    final service = await _db.getChild(FirebaseDataPaths.services, serviceId);

    final bookingRef =
        _db.ref('${FirebaseDataPaths.users}/${user.uid}/bookings').push();
    final bookingId = bookingRef.key!;

    final payload = {
      'id': bookingId,
      'salon_id': salonId,
      'service_id': serviceId,
      'date_time': dateTime.toIso8601String(),
      'status': 'pending',
      'salon_name': salon?['name'],
      'service_name': service?['name'],
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    await bookingRef.set(payload);
    await _db.ref('${FirebaseDataPaths.takenSlots}/$slotKey').set(true);

    return BookingModel.fromJson(payload);
  }

  @override
  Future<List<TimeSlotModel>> getAvailableSlots({
    required String salonId,
    required String serviceId,
    required DateTime date,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final slots = <TimeSlotModel>[];

    for (final hour in _slotHours) {
      for (final minute in [0, 30]) {
        if (hour == 20 && minute == 30) continue;
        final slotTime = DateTime(day.year, day.month, day.day, hour, minute);
        final slotKey = _slotKey(salonId, serviceId, slotTime);
        final taken =
            await _db.ref('${FirebaseDataPaths.takenSlots}/$slotKey').get();
        final isTaken = taken.exists && taken.value == true;
        slots.add(TimeSlotModel(dateTime: slotTime, available: !isTaken));
      }
    }

    return slots;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final user = _requireUser();
    final bookingPath =
        '${FirebaseDataPaths.users}/${user.uid}/bookings/$bookingId';
    final snapshot = await _db.ref(bookingPath).get();
    if (!snapshot.exists || snapshot.value == null) {
      throw const ServerException(message: 'cancel_failed');
    }

    final data = Map<String, dynamic>.from(snapshot.value! as Map);
    final salonId = data['salon_id']?.toString() ?? '';
    final serviceId = data['service_id']?.toString() ?? '';
    final dateTime = DateTime.parse(data['date_time'] as String);
    final slotKey = _slotKey(salonId, serviceId, dateTime);

    await _db.ref(bookingPath).update({'status': 'cancelled'});
    await _db.ref('${FirebaseDataPaths.takenSlots}/$slotKey').remove();
  }

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'invalid_credentials');
    }
    return user;
  }

  String _slotKey(String salonId, String serviceId, DateTime dateTime) {
    final normalized = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    return '$salonId/$serviceId/${normalized.toIso8601String()}'
        .replaceAll(':', '-');
  }
}
