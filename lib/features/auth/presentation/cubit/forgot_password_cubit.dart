import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordInitial());

  final AuthRepository _repository;

  Future<void> submit(String email) async {
    emit(const ForgotPasswordLoading());
    try {
      await _repository.requestPasswordReset(email: email);
      emit(const ForgotPasswordSuccess());
    } on NetworkException catch (e) {
      emit(ForgotPasswordFailure(e.message ?? 'network_error'));
    } on ServerException catch (e) {
      emit(ForgotPasswordFailure(e.message ?? 'forgot_password_failed'));
    } catch (_) {
      emit(const ForgotPasswordFailure('network_error'));
    }
  }
}
