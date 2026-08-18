import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class IResendResetCodeState extends Equatable {
  const IResendResetCodeState();
}

final class ResendResetCodeInitial extends IResendResetCodeState {
  @override
  List<Object> get props => [];
}

final class ResendResetCodeLoading extends IResendResetCodeState {
  @override
  List<Object> get props => [];
}

final class ResendResetCodeLoaded extends IResendResetCodeState {
  final BaseModel<UserModel>? userModel;

  const ResendResetCodeLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class ResendResetCodeFailed extends IResendResetCodeState {
  final String message;

  const ResendResetCodeFailed(this.message);

  @override
  List<Object> get props => [message];
}
