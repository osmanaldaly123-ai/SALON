import 'package:equatable/equatable.dart';

class Service extends Equatable {
  const Service({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.durationMinutes,
    this.imageUrl,
    this.salonId,
  });

  final String id;
  final String name;
  final double price;
  final String? description;
  final int? durationMinutes;
  final String? imageUrl;
  final String? salonId;

  @override
  List<Object?> get props =>
      [id, name, price, description, durationMinutes, imageUrl, salonId];
}
