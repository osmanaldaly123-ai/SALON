import '../../../auth/domain/entities/user.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  Future<User> getProfile() => _remote.getProfile();

  @override
  Future<User> updateProfile({String? name, String? phone}) =>
      _remote.updateProfile(name: name, phone: phone);

  @override
  Future<List<Booking>> getBookingHistory() => _remote.getBookingHistory();
}
