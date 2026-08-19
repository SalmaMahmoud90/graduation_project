import 'package:a_tareqaak/domain/entity/auth/resend_reset_code/resend_reset_code.dart';
import 'package:equatable/equatable.dart';

class ResendResetCodeCubitState extends Equatable {
  final ResendResetCodeEntity? entity;

  const ResendResetCodeCubitState({required this.entity});

  ResendResetCodeCubitState copyWith({
    ResendResetCodeEntity? entity,
  }) {
    return ResendResetCodeCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}
