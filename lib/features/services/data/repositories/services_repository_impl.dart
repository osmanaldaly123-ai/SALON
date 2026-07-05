import '../../../../core/demo/demo_data.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_remote_datasource.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  ServicesRepositoryImpl(this._remote, this._guest);

  final ServicesRemoteDataSource _remote;
  final GuestSessionService _guest;

  @override
  Future<List<Service>> getServices({String? salonId}) {
    if (_guest.isGuest) {
      return Future.value(DemoData.getServices(salonId: salonId));
    }
    return _remote.getServices(salonId: salonId);
  }
}
