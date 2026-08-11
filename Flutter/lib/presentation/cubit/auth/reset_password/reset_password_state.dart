
// حالة الكيوبيت الخاصة ببيانات نموذج إعادة تعيين كلمة المرور
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';
import 'package:equatable/equatable.dart';

class ResetPasswordCubitState extends Equatable {
  final ResetPasswordEntity? entity;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;

  const ResetPasswordCubitState({
    required this.entity,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
  });

  ResetPasswordCubitState copyWith({
    ResetPasswordEntity? entity,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
  }) {
    return ResetPasswordCubitState(
      entity: entity ?? this.entity,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
    );
  }

  @override
  List<Object?> get props => [
        entity,
        isPasswordObscured,
        isConfirmPasswordObscured,
      ];
}