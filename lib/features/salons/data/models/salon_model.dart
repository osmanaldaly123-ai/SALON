import '../../domain/entities/salon.dart';

class SalonModel extends Salon {
  const SalonModel({
    required super.id,
    required super.name,
    super.description,
    super.imageUrl,
    super.rating,
    super.address,
    super.distance,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      address: json['address'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }
}
