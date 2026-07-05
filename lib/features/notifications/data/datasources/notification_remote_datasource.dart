import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

abstract class NotificationRemoteDataSource {
  Future<void> registerFcmToken({
    required String token,
    required String platform,
  });

  Future<void> unregisterFcmToken();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> registerFcmToken({
    required String token,
    required String platform,
  }) async {
    await _client.post(
      ApiConstants.fcmToken,
      data: {
        'token': token,
        'platform': platform,
      },
    );
  }

  @override
  Future<void> unregisterFcmToken() async {
    await _client.delete(ApiConstants.fcmToken);
  }
}
