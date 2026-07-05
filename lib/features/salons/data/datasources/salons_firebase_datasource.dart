import '../../../../core/firebase/firebase_data_paths.dart';
import '../../../../core/firebase/realtime_database_client.dart';
import '../models/salon_model.dart';

abstract class SalonsFirebaseDataSource {
  Future<List<SalonModel>> getSalons({String? query});
  Future<SalonModel> getSalonById(String id);
}

class SalonsFirebaseDataSourceImpl implements SalonsFirebaseDataSource {
  SalonsFirebaseDataSourceImpl(this._db);

  final RealtimeDatabaseClient _db;

  @override
  Future<List<SalonModel>> getSalons({String? query}) async {
    final rows = await _db.listChildren(FirebaseDataPaths.salons);
    var salons = rows.map(SalonModel.fromJson).toList();

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      salons = salons
          .where(
            (s) =>
                s.name.toLowerCase().contains(q) ||
                (s.address?.toLowerCase().contains(q) ?? false) ||
                (s.description?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }

    return salons;
  }

  @override
  Future<SalonModel> getSalonById(String id) async {
    final row = await _db.getChild(FirebaseDataPaths.salons, id);
    if (row == null) {
      throw StateError('Salon not found: $id');
    }
    return SalonModel.fromJson(row);
  }
}
