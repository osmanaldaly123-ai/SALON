import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.price,
    super.description,
    super.durationMinutes,
    super.imageUrl,
    super.salonId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String?,
      durationMinutes: json['duration_minutes'] as int? ??
          json['durationMinutes'] as int?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      salonId: json['salon_id']?.toString() ?? json['salonId']?.toString(),
    );
  }
}
