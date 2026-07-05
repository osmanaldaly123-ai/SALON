import '../../../../core/config/env.dart';
import '../../../../core/demo/demo_data.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../domain/entities/salon.dart';
import '../../domain/repositories/salons_repository.dart';
import '../datasources/salons_firebase_datasource.dart';
import '../datasources/salons_remote_datasource.dart';

class SalonsRepositoryImpl implements SalonsRepository {
  SalonsRepositoryImpl(
    this._remote,
    this._firebase,
    this._guest,
  );

  final SalonsRemoteDataSource _remote;
  final SalonsFirebaseDataSource? _firebase;
  final GuestSessionService _guest;

  bool get _useFirebase =>
      Env.isFirebaseBackend && _firebase != null;

  @override
  Future<List<Salon>> getSalons({String? query}) {
    if (_useFirebase) return _firebase!.getSalons(query: query);
    if (_guest.isGuest) {
      return Future.value(DemoData.getSalons(query: query));
    }
    return _remote.getSalons(query: query);
  }

  @override
  Future<Salon> getSalonById(String id) {
    if (_useFirebase) return _firebase!.getSalonById(id);
    if (_guest.isGuest) {
      return Future.value(DemoData.getSalonById(id));
    }
    return _remote.getSalonById(id);
  }
}
