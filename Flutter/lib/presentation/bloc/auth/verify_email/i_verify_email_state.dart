
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';


sealed class IVerifyEmailState extends Equatable {
  const IVerifyEmailState();
}

final class VerifyEmailInitial extends IVerifyEmailState {
  @override
  List<Object> get props => [];
}

final class VerifyEmailLoading extends IVerifyEmailState {
  @override
  List<Object> get props => [];
}

final class VerifyEmailLoaded extends IVerifyEmailState {
  final BaseModel<UserModel>? userModel;

  const VerifyEmailLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class VerifyEmailFailed extends IVerifyEmailState {
  final String message;

  const VerifyEmailFailed(this.message);

  @override
  List<Object> get props => [message];
}