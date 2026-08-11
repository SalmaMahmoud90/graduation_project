
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IForgotPasswordEvent extends Equatable {
  const IForgotPasswordEvent();
}

// 👈 اسم الحدث المعتمد المطابق لقوافل ForgotPasswordEvent
final class ForgotPasswordEvent extends IForgotPasswordEvent {
  final ForgotPasswordEntity entity;

  const ForgotPasswordEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}