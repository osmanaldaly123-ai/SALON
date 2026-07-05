/// Application-wide environment configuration.
/// Set [API_BASE_URL] via `--dart-define` when the backend is ready.
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  /// `false` until the client provides a real API base URL.
  static bool get isApiConfigured =>
      baseUrl.isNotEmpty && !baseUrl.contains('example.com');
}
