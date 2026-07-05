import '../../../auth/domain/entities/user.dart';
import '../../../booking/domain/entities/booking.dart';

abstract class ProfileRepository {
  Future<User> getProfile();
  Future<User> updateProfile({String? name, String? phone});
  Future<List<Booking>> getBookingHistory();
}
