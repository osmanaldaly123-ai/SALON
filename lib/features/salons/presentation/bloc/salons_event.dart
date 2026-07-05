part of 'salons_bloc.dart';

sealed class SalonsEvent extends Equatable {
  const SalonsEvent();

  @override
  List<Object?> get props => [];
}

final class SalonsLoadRequested extends SalonsEvent {
  const SalonsLoadRequested({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}

final class SalonsSearchChanged extends SalonsEvent {
  const SalonsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SalonsRefreshRequested extends SalonsEvent {
  const SalonsRefreshRequested();
}
