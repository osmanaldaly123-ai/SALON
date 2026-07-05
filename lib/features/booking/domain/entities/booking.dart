import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.salonId,
    required this.serviceId,
    required this.dateTime,
    required this.status,
    this.salonName,
    this.serviceName,
    this.notes,
  });

  final String id;
  final String salonId;
  final String serviceId;
  final DateTime dateTime;
  final BookingStatus status;
  final String? salonName;
  final String? serviceName;
  final String? notes;

  @override
  List<Object?> get props =>
      [id, salonId, serviceId, dateTime, status, salonName, serviceName, notes];
}
