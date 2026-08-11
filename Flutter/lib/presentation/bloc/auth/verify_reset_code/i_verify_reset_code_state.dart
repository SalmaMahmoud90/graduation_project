
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class IVerifyResetCodeState extends Equatable {
  const IVerifyResetCodeState();
}

final class VerifyResetCodeInitial extends IVerifyResetCodeState {
  @override
  List<Object> get props => [];
}

final class VerifyResetCodeLoading extends IVerifyResetCodeState {
  @override
  List<Object> get props => [];
}

final class VerifyResetCodeLoaded extends IVerifyResetCodeState {
  final BaseModel<UserModel>? userModel;

  const VerifyResetCodeLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class VerifyResetCodeFailed extends IVerifyResetCodeState {
  final String message;

  const VerifyResetCodeFailed(this.message);

  @override
  List<Object> get props => [message];
}