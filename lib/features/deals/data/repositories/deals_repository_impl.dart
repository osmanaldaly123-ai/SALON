import '../../../../core/demo/demo_data.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../domain/entities/deal.dart';
import '../../domain/repositories/deals_repository.dart';
import '../datasources/deals_remote_datasource.dart';

class DealsRepositoryImpl implements DealsRepository {
  DealsRepositoryImpl(this._remote, this._guest);

  final DealsRemoteDataSource _remote;
  final GuestSessionService _guest;

  @override
  Future<List<Deal>> getDeals({String? salonId}) {
    if (_guest.isGuest) {
      return Future.value(DemoData.getDeals(salonId: salonId));
    }
    return _remote.getDeals(salonId: salonId);
  }
}
