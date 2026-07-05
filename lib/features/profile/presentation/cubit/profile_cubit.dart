import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class ProfileFailure extends ProfileState {
  const ProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileLoading());

  final ProfileRepository _repository;

  Future<void> load() async {
    emit(const ProfileLoading());
    await _fetch();
  }

  Future<void> update({required String name, String? phone}) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    emit(ProfileUpdating(current.user));

    try {
      final user = await _repository.updateProfile(name: name, phone: phone);
      emit(ProfileLoaded(user));
    } on ServerException catch (e) {
      emit(ProfileFailure(e.message ?? 'update_failed'));
      emit(ProfileLoaded(current.user));
    } catch (_) {
      emit(const ProfileFailure('update_failed'));
      emit(ProfileLoaded(current.user));
    }
  }

  Future<void> _fetch() async {
    try {
      final user = await _repository.getProfile();
      emit(ProfileLoaded(user));
    } on ServerException catch (e) {
      emit(ProfileFailure(e.message ?? 'load_failed'));
    } catch (_) {
      emit(const ProfileFailure('load_failed'));
    }
  }
}
