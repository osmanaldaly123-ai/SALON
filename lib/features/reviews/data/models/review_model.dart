import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.rating,
    required super.userName,
    super.comment,
    super.createdAt,
    super.salonId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      userName: json['user_name'] as String? ?? json['userName'] as String? ?? '',
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      salonId: json['salon_id']?.toString() ?? json['salonId']?.toString(),
    );
  }
}
