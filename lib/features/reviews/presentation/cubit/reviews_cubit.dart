import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/reviews_repository.dart';

sealed class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

final class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

final class ReviewsLoaded extends ReviewsState {
  const ReviewsLoaded({
    required this.reviews,
    required this.averageRating,
  });

  final List<Review> reviews;
  final double averageRating;

  @override
  List<Object?> get props => [reviews, averageRating];
}

final class ReviewsSubmitting extends ReviewsState {
  const ReviewsSubmitting(this.reviews, this.averageRating);

  final List<Review> reviews;
  final double averageRating;

  @override
  List<Object?> get props => [reviews, averageRating];
}

final class ReviewsFailure extends ReviewsState {
  const ReviewsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit(this._repository) : super(const ReviewsLoading());

  final ReviewsRepository _repository;
  String? _salonId;

  Future<void> load(String salonId) async {
    _salonId = salonId;
    emit(const ReviewsLoading());
    await _fetch();
  }

  Future<void> refresh() async {
    if (_salonId == null) return;
    await _fetch();
  }

  Future<void> submit({
    required String salonId,
    required double rating,
    String? comment,
  }) async {
    final current = state;
    List<Review> existing = [];
    var average = 0.0;
    if (current is ReviewsLoaded) {
      existing = current.reviews;
      average = current.averageRating;
    } else if (current is ReviewsSubmitting) {
      existing = current.reviews;
      average = current.averageRating;
    }

    emit(ReviewsSubmitting(existing, average));

    try {
      await _repository.submitReview(
        salonId: salonId,
        rating: rating,
        comment: comment,
      );
      _salonId = salonId;
      await _fetch();
    } on ServerException catch (e) {
      emit(ReviewsFailure(e.message ?? 'review_failed'));
      if (existing.isNotEmpty) {
        emit(ReviewsLoaded(reviews: existing, averageRating: average));
      }
    } catch (_) {
      emit(const ReviewsFailure('review_failed'));
      if (existing.isNotEmpty) {
        emit(ReviewsLoaded(reviews: existing, averageRating: average));
      }
    }
  }

  Future<void> _fetch() async {
    if (_salonId == null) return;

    try {
      final reviews = await _repository.getReviews(salonId: _salonId!);
      emit(ReviewsLoaded(
        reviews: reviews,
        averageRating: _calculateAverage(reviews),
      ));
    } on ServerException catch (e) {
      emit(ReviewsFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const ReviewsFailure('load_failed'));
    }
  }

  double _calculateAverage(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<double>(0, (total, r) => total + r.rating);
    return sum / reviews.length;
  }
}
