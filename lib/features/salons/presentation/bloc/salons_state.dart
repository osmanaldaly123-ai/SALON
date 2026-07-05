part of 'salons_bloc.dart';

sealed class SalonsState extends Equatable {
  const SalonsState();

  @override
  List<Object?> get props => [];
}

final class SalonsInitial extends SalonsState {
  const SalonsInitial();
}

final class SalonsLoading extends SalonsState {
  const SalonsLoading();
}

final class SalonsLoaded extends SalonsState {
  const SalonsLoaded(this.salons, {this.query});

  final List<Salon> salons;
  final String? query;

  @override
  List<Object?> get props => [salons, query];
}

final class SalonsFailure extends SalonsState {
  const SalonsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
