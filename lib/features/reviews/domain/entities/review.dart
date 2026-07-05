import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.rating,
    required this.userName,
    this.comment,
    this.createdAt,
    this.salonId,
  });

  final String id;
  final double rating;
  final String userName;
  final String? comment;
  final DateTime? createdAt;
  final String? salonId;

  @override
  List<Object?> get props => [id, rating, userName, comment, createdAt, salonId];
}
