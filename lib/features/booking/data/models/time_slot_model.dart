import '../../domain/entities/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.dateTime,
    super.available,
  });

  factory TimeSlotModel.fromJson(
    Map<String, dynamic> json, {
    required DateTime date,
  }) {
    final available = json['available'] as bool? ?? true;

    final dateTimeValue = json['date_time'] as String? ??
        json['dateTime'] as String? ??
        json['datetime'] as String?;

    if (dateTimeValue != null && dateTimeValue.isNotEmpty) {
      return TimeSlotModel(
        dateTime: DateTime.parse(dateTimeValue),
        available: available,
      );
    }

    final timeValue = json['time'] as String? ??
        json['slot'] as String? ??
        json['start_time'] as String? ??
        json['startTime'] as String? ??
        '';

    return TimeSlotModel(
      dateTime: _combineDateAndTime(date, timeValue),
      available: available,
    );
  }

  static DateTime _combineDateAndTime(DateTime date, String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return DateTime(date.year, date.month, date.day, hour, minute);
    }
    return date;
  }
}
