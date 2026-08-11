
import 'package:a_tareqaak/domain/entity/auth/resend_verification/resend_verification_entity.dart';
import 'package:equatable/equatable.dart';


sealed class IResendVerificationEvent extends Equatable {
  const IResendVerificationEvent();
}

final class ResendVerificationEvent extends IResendVerificationEvent {
  final ResendVerificationEntity entity;

  const ResendVerificationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}