import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';

ServerException mapFirebaseAuthException(FirebaseAuthException e) {
  final code = e.code;
  final message = switch (code) {
    'wrong-password' ||
    'invalid-credential' ||
    'user-not-found' ||
    'invalid-email' =>
      'invalid_credentials',
    'email-already-in-use' => 'email_already_exists',
    'weak-password' => 'password_too_short',
    'network-request-failed' => 'network_error',
    'too-many-requests' => 'login_failed',
    _ => 'login_failed',
  };
  return ServerException(message: message);
}

ServerException mapFirebaseAuthRegisterException(FirebaseAuthException e) {
  final code = e.code;
  final message = switch (code) {
    'email-already-in-use' => 'email_already_exists',
    'weak-password' => 'password_too_short',
    'invalid-email' => 'invalid_email',
    'network-request-failed' => 'network_error',
    _ => 'register_failed',
  };
  return ServerException(message: message);
}
