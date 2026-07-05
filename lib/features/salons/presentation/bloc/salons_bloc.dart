import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/salon.dart';
import '../../domain/repositories/salons_repository.dart';

part 'salons_event.dart';
part 'salons_state.dart';

class SalonsBloc extends Bloc<SalonsEvent, SalonsState> {
  SalonsBloc(this._repository) : super(const SalonsInitial()) {
    on<SalonsLoadRequested>(_onLoadRequested);
    on<SalonsSearchChanged>(_onSearchChanged);
    on<SalonsRefreshRequested>(_onRefreshRequested);
  }

  final SalonsRepository _repository;
  String? _currentQuery;

  Future<void> _onLoadRequested(
    SalonsLoadRequested event,
    Emitter<SalonsState> emit,
  ) async {
    _currentQuery = event.query;
    emit(const SalonsLoading());
    await _fetch(emit);
  }

  Future<void> _onSearchChanged(
    SalonsSearchChanged event,
    Emitter<SalonsState> emit,
  ) async {
    _currentQuery = event.query.isEmpty ? null : event.query;
    emit(const SalonsLoading());
    await _fetch(emit);
  }

  Future<void> _onRefreshRequested(
    SalonsRefreshRequested event,
    Emitter<SalonsState> emit,
  ) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<SalonsState> emit) async {
    try {
      final salons = await _repository.getSalons(
        query: _currentQuery,
      );
      emit(SalonsLoaded(salons, query: _currentQuery));
    } on ServerException catch (e) {
      emit(SalonsFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const SalonsFailure('load_failed'));
    }
  }
}
