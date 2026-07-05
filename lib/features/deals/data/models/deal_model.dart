import '../../domain/entities/deal.dart';

class DealModel extends Deal {
  const DealModel({
    required super.id,
    required super.title,
    required super.discountPercent,
    super.description,
    super.imageUrl,
    super.validUntil,
    super.salonId,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ??
          (json['discountPercent'] as num?)?.toDouble() ??
          0,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      validUntil: json['valid_until'] != null
          ? DateTime.tryParse(json['valid_until'] as String)
          : null,
      salonId: json['salon_id']?.toString() ?? json['salonId']?.toString(),
    );
  }
}
