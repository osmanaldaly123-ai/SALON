import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../deals/domain/entities/deal.dart';
import '../../../deals/domain/repositories/deals_repository.dart';
import '../../../services/domain/entities/service.dart';
import '../../../services/domain/repositories/services_repository.dart';
import '../../domain/entities/salon.dart';
import '../../domain/repositories/salons_repository.dart';

sealed class SalonDetailState extends Equatable {
  const SalonDetailState();

  @override
  List<Object?> get props => [];
}

final class SalonDetailLoading extends SalonDetailState {
  const SalonDetailLoading();
}

final class SalonDetailLoaded extends SalonDetailState {
  const SalonDetailLoaded({
    required this.salon,
    required this.services,
    required this.deals,
  });

  final Salon salon;
  final List<Service> services;
  final List<Deal> deals;

  @override
  List<Object?> get props => [salon, services, deals];
}

final class SalonDetailFailure extends SalonDetailState {
  const SalonDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SalonDetailCubit extends Cubit<SalonDetailState> {
  SalonDetailCubit(
    this._salonsRepository,
    this._servicesRepository,
    this._dealsRepository,
  ) : super(const SalonDetailLoading());

  final SalonsRepository _salonsRepository;
  final ServicesRepository _servicesRepository;
  final DealsRepository _dealsRepository;

  Future<void> load(String salonId) async {
    emit(const SalonDetailLoading());
    try {
      final results = await Future.wait([
        _salonsRepository.getSalonById(salonId),
        _servicesRepository.getServices(salonId: salonId),
        _dealsRepository.getDeals(salonId: salonId),
      ]);

      emit(SalonDetailLoaded(
        salon: results[0] as Salon,
        services: results[1] as List<Service>,
        deals: results[2] as List<Deal>,
      ));
    } on ServerException catch (e) {
      emit(SalonDetailFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const SalonDetailFailure('load_failed'));
    }
  }
}
