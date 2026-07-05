import 'package:equatable/equatable.dart';

class BookingDraft extends Equatable {
  const BookingDraft({
    this.salonId,
    this.salonName,
    this.serviceId,
    this.serviceName,
    this.price,
    this.date,
    this.slot,
    this.notes,
  });

  final String? salonId;
  final String? salonName;
  final String? serviceId;
  final String? serviceName;
  final double? price;
  final DateTime? date;
  final DateTime? slot;
  final String? notes;

  bool get hasSalon => salonId != null && salonId!.isNotEmpty;
  bool get hasService => serviceId != null && serviceId!.isNotEmpty;
  bool get hasDate => date != null;
  bool get hasSlot => slot != null;

  BookingDraft copyWith({
    String? salonId,
    String? salonName,
    String? serviceId,
    String? serviceName,
    double? price,
    DateTime? date,
    DateTime? slot,
    String? notes,
    bool clearSlot = false,
    bool clearDate = false,
  }) {
    return BookingDraft(
      salonId: salonId ?? this.salonId,
      salonName: salonName ?? this.salonName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      price: price ?? this.price,
      date: clearDate ? null : (date ?? this.date),
      slot: clearSlot ? null : (slot ?? this.slot),
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props =>
      [salonId, salonName, serviceId, serviceName, price, date, slot, notes];
}

enum BookingStep { service, dateTime, summary }
