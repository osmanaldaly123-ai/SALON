import '../../../booking/domain/entities/booking.dart';

extension BookingX on Booking {
  bool get isUpcoming {
    if (status == BookingStatus.cancelled ||
        status == BookingStatus.completed) {
      return false;
    }
    return dateTime.isAfter(DateTime.now());
  }

  bool get canCancel {
    return isUpcoming &&
        (status == BookingStatus.pending || status == BookingStatus.confirmed);
  }
}
