
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IResetPasswordEvent extends Equatable {
  const IResetPasswordEvent();
}

final class ResetPasswordEvent extends IResetPasswordEvent {
  final ResetPasswordEntity entity;

  const ResetPasswordEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}