import 'package:equatable/equatable.dart';

class Deal extends Equatable {
  const Deal({
    required this.id,
    required this.title,
    required this.discountPercent,
    this.description,
    this.imageUrl,
    this.validUntil,
    this.salonId,
  });

  final String id;
  final String title;
  final double discountPercent;
  final String? description;
  final String? imageUrl;
  final DateTime? validUntil;
  final String? salonId;

  @override
  List<Object?> get props =>
      [id, title, discountPercent, description, imageUrl, validUntil, salonId];
}
