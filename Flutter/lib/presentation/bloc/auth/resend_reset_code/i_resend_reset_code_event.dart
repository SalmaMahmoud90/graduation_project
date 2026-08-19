import 'package:a_tareqaak/domain/entity/auth/resend_reset_code/resend_reset_code.dart';
import 'package:equatable/equatable.dart';

sealed class IResendResetCodeEvent extends Equatable {
  const IResendResetCodeEvent();
}

final class ResendResetCodeEvent extends IResendResetCodeEvent {
  final ResendResetCodeEntity entity;

  const ResendResetCodeEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}
