import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.salonId,
    required super.serviceId,
    required super.dateTime,
    required super.status,
    super.salonName,
    super.serviceName,
    super.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      salonId: json['salon_id']?.toString() ?? json['salonId']?.toString() ?? '',
      serviceId:
          json['service_id']?.toString() ?? json['serviceId']?.toString() ?? '',
      dateTime: DateTime.parse(
        json['date_time'] as String? ?? json['dateTime'] as String? ?? '',
      ),
      status: _parseStatus(json['status'] as String?),
      salonName: json['salon_name'] as String? ?? json['salonName'] as String?,
      serviceName:
          json['service_name'] as String? ?? json['serviceName'] as String?,
      notes: json['notes'] as String?,
    );
  }

  static BookingStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}
