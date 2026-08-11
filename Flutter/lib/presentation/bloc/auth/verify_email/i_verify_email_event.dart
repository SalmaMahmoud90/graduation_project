

import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';
import 'package:equatable/equatable.dart';


sealed class IVerifyEmailEvent extends Equatable {
  const IVerifyEmailEvent();
}

final class VerifyEmailEvent extends IVerifyEmailEvent {
  final VerifyEmailEntity entity;

  const VerifyEmailEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}