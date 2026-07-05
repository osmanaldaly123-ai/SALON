import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../../core/error/exceptions.dart';
import '../../../../core/firebase/firebase_auth_client.dart';
import '../../../../core/firebase/firebase_auth_errors.dart';
import '../../../../core/firebase/firebase_data_paths.dart';
import '../../../../core/firebase/realtime_database_client.dart';
import '../models/auth_session_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthFirebaseDataSource implements AuthRemoteDataSource {
  AuthFirebaseDataSource(this._auth, this._db);

  final FirebaseAuthClient _auth;
  final RealtimeDatabaseClient _db;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'login_failed');
      }
      final profile = await _loadUserProfile(user);
      return AuthSessionModel(
        user: profile,
        token: user.uid,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final credential = await _auth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const ServerException(message: 'register_failed');
      }

      await user.updateDisplayName(name.trim());

      final profile = UserModel(
        id: user.uid,
        name: name.trim(),
        email: email.trim(),
        phone: phone?.trim().isEmpty ?? true ? null : phone!.trim(),
      );

      await _db.ref('${FirebaseDataPaths.users}/${user.uid}').set(profile.toJson());

      return AuthSessionModel(user: profile, token: user.uid);
    } on fb.FirebaseAuthException catch (e) {
      throw mapFirebaseAuthRegisterException(e);
    }
  }

  @override
  Future<void> logout() async {
    await _auth.instance.signOut();
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _auth.instance.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  Future<UserModel> _loadUserProfile(fb.User user) async {
    final row = await _db.getChild(FirebaseDataPaths.users, user.uid);
    if (row != null) {
      return UserModel.fromJson(row);
    }
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
