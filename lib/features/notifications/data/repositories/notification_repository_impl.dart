import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remote);

  final NotificationRemoteDataSource _remote;

  @override
  Future<void> registerToken({
    required String token,
    required String platform,
  }) async {
    try {
      await _remote.registerFcmToken(token: token, platform: platform);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> unregisterToken() async {
    try {
      await _remote.unregisterFcmToken();
    } on ServerException {
      rethrow;
    }
  }
}
