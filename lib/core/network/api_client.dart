import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../error/exceptions.dart';
import 'auth_interceptor.dart';
import 'token_refresh_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  ApiClient({FlutterSecureStorage? storage, void Function()? onSessionExpired})
      : _storage = storage ?? const FlutterSecureStorage(),
        _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _onSessionExpired = onSessionExpired;
    _dio.interceptors.addAll([
      AuthInterceptor(_storage),
      TokenRefreshInterceptor(
        dio: _dio,
        storage: _storage,
        getOnSessionExpired: () => _onSessionExpired,
      ),
      if (!kReleaseMode)
        LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final FlutterSecureStorage _storage;
  void Function()? _onSessionExpired;
  final Dio _dio;

  set onSessionExpired(void Function()? handler) {
    _onSessionExpired = handler;
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      return await _dio.put<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await _dio.delete<T>(path);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (_isNetworkError(e)) {
      return const NetworkException(message: 'network_error');
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String? message;
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? data['error'] as String?;
    }
    message ??= e.message;

    if (statusCode == 401) {
      return ServerException(message: 'invalid_credentials', statusCode: statusCode);
    }
    if (statusCode == 409) {
      return ServerException(message: 'email_already_exists', statusCode: statusCode);
    }

    return ServerException(message: message, statusCode: statusCode);
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.type == DioExceptionType.unknown && e.response == null);
  }
}
