import 'env.dart';

class AppConfig {
  AppConfig._();

  static const String appName = 'Salon';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = Env.baseUrl;
  static const String firebaseDatabaseUrl = Env.firebaseDatabaseUrl;
  static bool get isApiConfigured => Env.isApiConfigured;
  static bool get isFirebaseBackend => Env.isFirebaseBackend;
  static bool get isFirebaseDatabaseConfigured =>
      Env.isFirebaseDatabaseConfigured;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
