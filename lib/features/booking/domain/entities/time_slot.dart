import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  const TimeSlot({
    required this.dateTime,
    this.available = true,
  });

  final DateTime dateTime;
  final bool available;

  @override
  List<Object?> get props => [dateTime, available];
}
