

import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';



sealed class IRegisterState extends Equatable {
  const IRegisterState();
}

final class RegisterInitial extends IRegisterState {
  @override
  List<Object> get props => [];
}

final class RegisterLoading extends IRegisterState {
  @override
  List<Object> get props => [];
}

final class RegisterLoaded extends IRegisterState {
  final BaseModel<UserModel>? userModel;

  const RegisterLoaded({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class RegisterFailed extends IRegisterState {
  final String message;

  const RegisterFailed(this.message);

  @override
  List<Object> get props => [message];
}