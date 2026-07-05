import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<ReviewModel>> getReviews({required String salonId});
  Future<ReviewModel> submitReview({
    required String salonId,
    required double rating,
    String? comment,
  });
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  ReviewsRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ReviewModel>> getReviews({required String salonId}) async {
    final response = await _client.get(ApiConstants.salonReviews(salonId));
    final list = response.data['data'] as List<dynamic>? ?? response.data as List;
    return list
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReviewModel> submitReview({
    required String salonId,
    required double rating,
    String? comment,
  }) async {
    final response = await _client.post(
      ApiConstants.reviews,
      data: {
        'salon_id': salonId,
        'rating': rating,
        if (comment != null) 'comment': comment,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return ReviewModel.fromJson(data);
  }
}
