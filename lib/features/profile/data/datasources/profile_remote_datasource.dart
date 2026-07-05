import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../booking/data/models/booking_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? name, String? phone});
  Future<List<BookingModel>> getBookingHistory();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<UserModel> getProfile() async {
    final response = await _client.get(ApiConstants.profile);
    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateProfile({String? name, String? phone}) async {
    final response = await _client.put(
      ApiConstants.profile,
      data: {
        'name': ?name,
        'phone': ?phone,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  @override
  Future<List<BookingModel>> getBookingHistory() async {
    final response = await _client.get(ApiConstants.bookingHistory);
    final list = response.data['data'] as List<dynamic>? ?? response.data as List;
    return list
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
