import '../../firebase_options.dart';

/// Application-wide environment configuration.
///
/// Runtime flags (pass via `--dart-define`):
/// - [API_BASE_URL] — REST backend
/// - [FIREBASE_DATABASE_URL] — Realtime Database URL from Firebase Console
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  /// Realtime Database URL (project: system-42ab7).
  static const String firebaseDatabaseUrl = String.fromEnvironment(
    'FIREBASE_DATABASE_URL',
    defaultValue: DefaultFirebaseOptions.defaultDatabaseUrl,
  );

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  /// `false` until the client provides a real API base URL.
  static bool get isApiConfigured =>
      baseUrl.isNotEmpty && !baseUrl.contains('example.com');

  /// `true` when Firebase Realtime Database URL is supplied at build/run time.
  static bool get isFirebaseDatabaseConfigured =>
      firebaseDatabaseUrl.isNotEmpty &&
      firebaseDatabaseUrl.startsWith('https://');

  /// Full backend via Firebase (auth, browse, bookings) — no REST API required.
  static bool get isFirebaseBackend => isFirebaseDatabaseConfigured;
}
