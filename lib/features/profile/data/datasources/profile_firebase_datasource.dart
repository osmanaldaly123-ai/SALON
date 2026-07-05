import '../../../../core/error/exceptions.dart';
import '../../../../core/firebase/firebase_auth_client.dart';
import '../../../../core/firebase/firebase_data_paths.dart';
import '../../../../core/firebase/realtime_database_client.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../booking/data/models/booking_model.dart';
import 'profile_remote_datasource.dart';

class ProfileFirebaseDataSource implements ProfileRemoteDataSource {
  ProfileFirebaseDataSource(this._auth, this._db);

  final FirebaseAuthClient _auth;
  final RealtimeDatabaseClient _db;

  @override
  Future<UserModel> getProfile() async {
    final uid = _requireUid();
    final row = await _db.getChild(FirebaseDataPaths.users, uid);
    if (row == null) {
      final user = _auth.currentUser!;
      return UserModel(
        id: uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    }
    return UserModel.fromJson(row);
  }

  @override
  Future<UserModel> updateProfile({String? name, String? phone}) async {
    final uid = _requireUid();
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;

    if (updates.isNotEmpty) {
      await _db.ref('${FirebaseDataPaths.users}/$uid').update(updates);
      if (name != null) {
        await _auth.currentUser?.updateDisplayName(name);
      }
    }

    return getProfile();
  }

  @override
  Future<List<BookingModel>> getBookingHistory() async {
    final uid = _requireUid();
    final rows =
        await _db.listChildren('${FirebaseDataPaths.users}/$uid/bookings');
    return rows.map(BookingModel.fromJson).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  String _requireUid() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw const ServerException(message: 'invalid_credentials');
    }
    return uid;
  }
}
