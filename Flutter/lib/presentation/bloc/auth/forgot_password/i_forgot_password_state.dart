
import 'package:a_tareqaak/data/models/auth/forgot_password_response/forgot_password_response_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class IForgotPasswordState extends Equatable {
  const IForgotPasswordState();
}

final class ForgotPasswordInitial extends IForgotPasswordState {
  @override
  List<Object> get props => [];
}

final class ForgotPasswordLoading extends IForgotPasswordState {
  @override
  List<Object> get props => [];
}

// 👈 اسم الحالة المعتمدة ForgotPasswordLoaded مع الخاصية responseModel
final class ForgotPasswordLoaded extends IForgotPasswordState {
  final BaseModel<ForgotPasswordResponseModel>? responseModel;

  const ForgotPasswordLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class ForgotPasswordFailed extends IForgotPasswordState {
  final String message;

  const ForgotPasswordFailed(this.message);

  @override
  List<Object> get props => [message];
}