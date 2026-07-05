import '../entities/review.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getReviews({required String salonId});
  Future<Review> submitReview({
    required String salonId,
    required double rating,
    String? comment,
  });
}
