
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';
import 'package:equatable/equatable.dart';


sealed class IVerifyResetCodeEvent extends Equatable {
  const IVerifyResetCodeEvent();
}

final class VerifyResetCodeEvent extends IVerifyResetCodeEvent {
  final VerifyResetCodeEntity entity;

  const VerifyResetCodeEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}