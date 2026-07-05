import '../../../../core/demo/demo_data.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../datasources/reviews_remote_datasource.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl(this._remote, this._guest);

  final ReviewsRemoteDataSource _remote;
  final GuestSessionService _guest;

  @override
  Future<List<Review>> getReviews({required String salonId}) {
    if (_guest.isGuest) {
      return Future.value(DemoData.getReviews(salonId));
    }
    return _remote.getReviews(salonId: salonId);
  }

  @override
  Future<Review> submitReview({
    required String salonId,
    required double rating,
    String? comment,
  }) {
    return _remote.submitReview(
      salonId: salonId,
      rating: rating,
      comment: comment,
    );
  }
}
