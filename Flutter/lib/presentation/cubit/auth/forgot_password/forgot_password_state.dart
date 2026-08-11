
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';
import 'package:equatable/equatable.dart';

class ForgotPasswordCubitState extends Equatable {
  final ForgotPasswordEntity? entity;

  const ForgotPasswordCubitState({required this.entity});

  ForgotPasswordCubitState copyWith({
    ForgotPasswordEntity? entity,
  }) {
    return ForgotPasswordCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}