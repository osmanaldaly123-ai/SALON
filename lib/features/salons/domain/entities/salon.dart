import 'package:equatable/equatable.dart';

class Salon extends Equatable {
  const Salon({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.rating,
    this.address,
    this.distance,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double? rating;
  final String? address;
  final double? distance;

  @override
  List<Object?> get props =>
      [id, name, description, imageUrl, rating, address, distance];
}
