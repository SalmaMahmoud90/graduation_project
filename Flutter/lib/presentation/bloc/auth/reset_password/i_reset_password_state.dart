import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class IResetPasswordState extends Equatable {
  const IResetPasswordState();
}

final class ResetPasswordInitial extends IResetPasswordState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordLoading extends IResetPasswordState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordLoaded extends IResetPasswordState {
  final BaseModel<UserModel>? userModel;

  const ResetPasswordLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class ResetPasswordFailed extends IResetPasswordState {
  final String message;

  const ResetPasswordFailed(this.message);

  @override
  List<Object> get props => [message];
}