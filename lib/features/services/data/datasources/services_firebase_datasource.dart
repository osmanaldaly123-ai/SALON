import '../../../../core/firebase/firebase_data_paths.dart';
import '../../../../core/firebase/realtime_database_client.dart';
import '../models/service_model.dart';

abstract class ServicesFirebaseDataSource {
  Future<List<ServiceModel>> getServices({String? salonId});
}

class ServicesFirebaseDataSourceImpl implements ServicesFirebaseDataSource {
  ServicesFirebaseDataSourceImpl(this._db);

  final RealtimeDatabaseClient _db;

  @override
  Future<List<ServiceModel>> getServices({String? salonId}) async {
    final rows = await _db.listChildren(FirebaseDataPaths.services);
    var services = rows.map(ServiceModel.fromJson).toList();

    if (salonId != null && salonId.isNotEmpty) {
      services = services.where((s) => s.salonId == salonId).toList();
    }

    return services;
  }
}
