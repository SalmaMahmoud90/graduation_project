
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';
import 'package:equatable/equatable.dart';

class VerifyResetCodeCubitState extends Equatable {
  final VerifyResetCodeEntity? entity;

  const VerifyResetCodeCubitState({required this.entity});

  VerifyResetCodeCubitState copyWith({
    VerifyResetCodeEntity? entity,
  }) {
    return VerifyResetCodeCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}