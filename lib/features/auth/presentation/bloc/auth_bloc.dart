import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/guest_session_service.dart';
import '../../../notifications/services/notification_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthGuestRequested>(_onGuestRequested);
    on<AuthSessionExpired>(_onSessionExpired);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _repository;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (sl<GuestSessionService>().isGuest) {
      emit(const AuthGuest());
      return;
    }

    final isLoggedIn = await _repository.isLoggedIn();
    emit(
      isLoggedIn
          ? const AuthAuthenticated()
          : const AuthUnauthenticated(),
    );
  }

  Future<void> _onGuestRequested(
    AuthGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    await sl<GuestSessionService>().enterGuestMode();
    emit(const AuthGuest());
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(
        email: event.email.trim(),
        password: event.password,
      );
      await sl<GuestSessionService>().exitGuestMode();
      emit(AuthAuthenticated(user: user));
    } on NetworkException catch (e) {
      emit(AuthFailure(e.message ?? 'network_error'));
    } on ServerException catch (e) {
      emit(AuthFailure(e.message ?? 'login_failed'));
    } catch (_) {
      emit(const AuthFailure('network_error'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
        name: event.name.trim(),
        email: event.email.trim(),
        password: event.password,
        phone: event.phone?.trim(),
      );
      await sl<GuestSessionService>().exitGuestMode();
      emit(AuthAuthenticated(user: user));
    } on NetworkException catch (e) {
      emit(AuthFailure(e.message ?? 'network_error'));
    } on ServerException catch (e) {
      emit(AuthFailure(e.message ?? 'register_failed'));
    } catch (_) {
      emit(const AuthFailure('network_error'));
    }
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated());
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    if (sl<GuestSessionService>().isGuest) {
      await sl<GuestSessionService>().exitGuestMode();
      emit(const AuthUnauthenticated());
      return;
    }

    if (isFirebaseEnabled) {
      await sl<NotificationService>().clearTokenOnLogout();
    }
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }
}
