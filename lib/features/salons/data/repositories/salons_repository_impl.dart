import '../../../../core/demo/demo_data.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../domain/entities/salon.dart';
import '../../domain/repositories/salons_repository.dart';
import '../datasources/salons_remote_datasource.dart';

class SalonsRepositoryImpl implements SalonsRepository {
  SalonsRepositoryImpl(this._remote, this._guest);

  final SalonsRemoteDataSource _remote;
  final GuestSessionService _guest;

  @override
  Future<List<Salon>> getSalons({String? query}) {
    if (_guest.isGuest) {
      return Future.value(DemoData.getSalons(query: query));
    }
    return _remote.getSalons(query: query);
  }

  @override
  Future<Salon> getSalonById(String id) {
    if (_guest.isGuest) {
      return Future.value(DemoData.getSalonById(id));
    }
    return _remote.getSalonById(id);
  }
}
