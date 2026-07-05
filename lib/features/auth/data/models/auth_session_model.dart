import '../../domain/entities/user.dart';
import 'user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  final UserModel user;
  final String token;
  final String? refreshToken;

  factory AuthSessionModel.fromResponse(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final userJson = data['user'] as Map<String, dynamic>? ??
        data['customer'] as Map<String, dynamic>? ??
        _extractUserFromRoot(data);

    final token = data['token'] as String? ??
        data['access_token'] as String? ??
        data['accessToken'] as String? ??
        json['token'] as String? ??
        json['access_token'] as String? ??
        '';

    final refreshToken = data['refresh_token'] as String? ??
        data['refreshToken'] as String? ??
        json['refresh_token'] as String?;

    return AuthSessionModel(
      user: UserModel.fromJson(userJson),
      token: token,
      refreshToken: refreshToken,
    );
  }

  static Map<String, dynamic> _extractUserFromRoot(Map<String, dynamic> data) {
    if (data.containsKey('id') && data.containsKey('email')) {
      return data;
    }
    return {};
  }

  User toEntity() => user;
}
