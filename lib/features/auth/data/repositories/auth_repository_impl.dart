import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/config/env.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/firebase/firebase_auth_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remote,
    this._storage, [
    this._firebaseAuth,
  ]);

  final AuthRemoteDataSource _remote;
  final FlutterSecureStorage _storage;
  final FirebaseAuthClient? _firebaseAuth;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remote.login(email: email, password: password);
      await _persistSession(session.token, session.refreshToken);
      return session.toEntity();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final session = await _remote.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      await _persistSession(session.token, session.refreshToken);
      return session.toEntity();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } on ServerException {
      // Clear local session even if remote logout fails.
    } finally {
      await _clearSession();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    if (Env.isFirebaseBackend && _firebaseAuth != null) {
      return _firebaseAuth.currentUser != null;
    }
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _remote.requestPasswordReset(email: email.trim());
  }

  Future<void> _persistSession(String token, String? refreshToken) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: refreshToken,
      );
    }
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }
}
