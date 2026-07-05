import '../../../../core/firebase/firebase_data_paths.dart';
import '../../../../core/firebase/realtime_database_client.dart';
import '../models/deal_model.dart';

abstract class DealsFirebaseDataSource {
  Future<List<DealModel>> getDeals({String? salonId});
}

class DealsFirebaseDataSourceImpl implements DealsFirebaseDataSource {
  DealsFirebaseDataSourceImpl(this._db);

  final RealtimeDatabaseClient _db;

  @override
  Future<List<DealModel>> getDeals({String? salonId}) async {
    final rows = await _db.listChildren(FirebaseDataPaths.deals);
    var deals = rows.map(DealModel.fromJson).toList();

    if (salonId != null && salonId.isNotEmpty) {
      deals = deals.where((d) => d.salonId == salonId).toList();
    }

    return deals;
  }
}
