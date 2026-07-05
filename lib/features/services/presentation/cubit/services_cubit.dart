import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/services_repository.dart';

sealed class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

final class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

final class ServicesLoaded extends ServicesState {
  const ServicesLoaded(this.services, {this.salonId});

  final List<Service> services;
  final String? salonId;

  @override
  List<Object?> get props => [services, salonId];
}

final class ServicesFailure extends ServicesState {
  const ServicesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this._repository) : super(const ServicesLoading());

  final ServicesRepository _repository;
  String? _salonId;

  Future<void> load({String? salonId}) async {
    _salonId = salonId;
    emit(const ServicesLoading());
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    try {
      final services = await _repository.getServices(salonId: _salonId);
      emit(ServicesLoaded(services, salonId: _salonId));
    } on ServerException catch (e) {
      emit(ServicesFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const ServicesFailure('load_failed'));
    }
  }
}
