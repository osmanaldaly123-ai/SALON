import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/deal.dart';
import '../../domain/repositories/deals_repository.dart';

sealed class DealsState extends Equatable {
  const DealsState();

  @override
  List<Object?> get props => [];
}

final class DealsLoading extends DealsState {
  const DealsLoading();
}

final class DealsLoaded extends DealsState {
  const DealsLoaded(this.deals, {this.salonId});

  final List<Deal> deals;
  final String? salonId;

  @override
  List<Object?> get props => [deals, salonId];
}

final class DealsFailure extends DealsState {
  const DealsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class DealsCubit extends Cubit<DealsState> {
  DealsCubit(this._repository) : super(const DealsLoading());

  final DealsRepository _repository;
  String? _salonId;

  Future<void> load({String? salonId}) async {
    _salonId = salonId;
    emit(const DealsLoading());
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    try {
      final deals = await _repository.getDeals(salonId: _salonId);
      emit(DealsLoaded(deals, salonId: _salonId));
    } on ServerException catch (e) {
      emit(DealsFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const DealsFailure('load_failed'));
    }
  }
}
