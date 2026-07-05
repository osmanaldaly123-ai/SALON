import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../deals/domain/entities/deal.dart';
import '../../../deals/domain/repositories/deals_repository.dart';
import '../../../salons/domain/entities/salon.dart';
import '../../../salons/domain/repositories/salons_repository.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.featuredSalons,
    required this.deals,
  });

  final List<Salon> featuredSalons;
  final List<Deal> deals;

  @override
  List<Object?> get props => [featuredSalons, deals];
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._salonsRepository, this._dealsRepository)
      : super(const HomeLoading());

  final SalonsRepository _salonsRepository;
  final DealsRepository _dealsRepository;

  Future<void> load() async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _salonsRepository.getSalons(),
        _dealsRepository.getDeals(),
      ]);
      final salons = results[0] as List<Salon>;
      final deals = results[1] as List<Deal>;

      emit(HomeLoaded(
        featuredSalons: salons.take(6).toList(),
        deals: deals.take(6).toList(),
      ));
    } on ServerException catch (e) {
      emit(HomeFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const HomeFailure('load_failed'));
    }
  }
}
