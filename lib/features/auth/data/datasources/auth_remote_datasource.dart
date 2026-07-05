import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });
  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  Future<void> logout();
  Future<void> requestPasswordReset({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthSessionModel.fromResponse(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _client.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
    return AuthSessionModel.fromResponse(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _client.post(ApiConstants.logout);
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _client.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }
}
