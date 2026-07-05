abstract class NotificationRepository {
  Future<void> registerToken({
    required String token,
    required String platform,
  });

  Future<void> unregisterToken();
}
