
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';


sealed class IResendVerificationState extends Equatable {
  const IResendVerificationState();
}

final class ResendVerificationInitial extends IResendVerificationState {
  @override
  List<Object> get props => [];
}

final class ResendVerificationLoading extends IResendVerificationState {
  @override
  List<Object> get props => [];
}

final class ResendVerificationLoaded extends IResendVerificationState {
  final BaseModel<UserModel>? userModel;

  const ResendVerificationLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class ResendVerificationFailed extends IResendVerificationState {
  final String message;

  const ResendVerificationFailed(this.message);

  @override
  List<Object> get props => [message];
}