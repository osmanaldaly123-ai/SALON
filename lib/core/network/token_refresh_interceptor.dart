import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required Dio dio,
    required FlutterSecureStorage storage,
    required void Function()? Function() getOnSessionExpired,
  })  : _dio = dio,
        _storage = storage,
        _getOnSessionExpired = getOnSessionExpired;

  final Dio _dio;
  final FlutterSecureStorage _storage;
  final void Function()? Function() _getOnSessionExpired;

  static const _retriedKey = 'token_refresh_retried';

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (statusCode != 401) {
      return handler.next(err);
    }

    if (_shouldSkipRefresh(path)) {
      if (path.contains(ApiConstants.refreshToken)) {
        await _expireSession();
      }
      return handler.next(err);
    }

    if (err.requestOptions.extra[_retriedKey] == true) {
      await _expireSession();
      return handler.next(err);
    }

    try {
      await _ensureFreshToken();
      final response = await _retry(err.requestOptions);
      return handler.resolve(response);
    } catch (_) {
      await _expireSession();
      return handler.next(err);
    }
  }

  bool _shouldSkipRefresh(String path) {
    return path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.register) ||
        path.contains(ApiConstants.forgotPassword) ||
        path.contains(ApiConstants.refreshToken);
  }

  Future<void> _ensureFreshToken() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken =
          await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        throw StateError('missing_refresh_token');
      }

      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {_retriedKey: true}),
      );

      final tokens = _parseTokens(response.data);
      if (tokens == null) {
        throw StateError('invalid_refresh_response');
      }

      await _storage.write(key: AppConstants.tokenKey, value: tokens.$1);
      if (tokens.$2 != null && tokens.$2!.isNotEmpty) {
        await _storage.write(
          key: AppConstants.refreshTokenKey,
          value: tokens.$2,
        );
      }

      _refreshCompleter!.complete();
    } catch (error, stackTrace) {
      _refreshCompleter!.completeError(error, stackTrace);
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  (String, String?)? _parseTokens(Map<String, dynamic>? json) {
    if (json == null) return null;

    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final token = data['token'] as String? ??
        data['access_token'] as String? ??
        data['accessToken'] as String?;
    final refreshToken = data['refresh_token'] as String? ??
        data['refreshToken'] as String?;

    if (token == null || token.isEmpty) return null;
    return (token, refreshToken);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        extra: {...requestOptions.extra, _retriedKey: true},
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveTimeout: requestOptions.receiveTimeout,
        sendTimeout: requestOptions.sendTimeout,
      ),
    );
  }

  Future<void> _expireSession() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    _getOnSessionExpired()?.call();
  }
}
