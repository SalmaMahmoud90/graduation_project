
// حالة الكيوبيت لنموذج إنشاء الحساب
import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';
import 'package:equatable/equatable.dart';

class RegisterCubitState extends Equatable {
  final RegisterEntity? entity;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final bool isTermsAccepted;

  const RegisterCubitState({
    required this.entity,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.isTermsAccepted = false,
  });

  RegisterCubitState copyWith({
    RegisterEntity? entity,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    bool? isTermsAccepted,
  }) {
    return RegisterCubitState(
      entity: entity ?? this.entity,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }

  @override
  List<Object?> get props => [
        entity,
        isPasswordObscured,
        isConfirmPasswordObscured,
        isTermsAccepted,
      ];
}