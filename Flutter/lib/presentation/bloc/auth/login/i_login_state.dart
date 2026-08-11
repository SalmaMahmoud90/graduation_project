

import 'package:a_tareqaak/data/models/auth/token/tokens_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class ILoginState extends Equatable {
  const ILoginState();
}

final class LoginInitial extends ILoginState {
  @override
  List<Object> get props => [];
}

final class LoginLoading extends ILoginState {
  @override
  List<Object> get props => [];
}

// 👈 اسم الحالة المعتمد المطابق لمشروع قوافل LoginLoaded
final class LoginLoaded extends ILoginState {
  final BaseModel<TokensModel>? tokensModel;

  const LoginLoaded({required this.tokensModel});

  @override
  List<Object?> get props => [tokensModel];
}

final class LoginFailed extends ILoginState {
  final String message;

  const LoginFailed(this.message);

  @override
  List<Object> get props => [message];
}