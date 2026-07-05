import '../../../../core/config/env.dart';
import '../../../../core/demo/demo_data.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_firebase_datasource.dart';
import '../datasources/services_remote_datasource.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  ServicesRepositoryImpl(
    this._remote,
    this._firebase,
    this._guest,
  );

  final ServicesRemoteDataSource _remote;
  final ServicesFirebaseDataSource? _firebase;
  final GuestSessionService _guest;

  bool get _useFirebase =>
      Env.isFirebaseBackend && _firebase != null;

  @override
  Future<List<Service>> getServices({String? salonId}) {
    if (_useFirebase) return _firebase!.getServices(salonId: salonId);
    if (_guest.isGuest) {
      return Future.value(DemoData.getServices(salonId: salonId));
    }
    return _remote.getServices(salonId: salonId);
  }
}
