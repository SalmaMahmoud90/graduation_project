
// حالة الكيوبيت الخاصة ببيانات نموذج تسجيل الدخول
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';
import 'package:equatable/equatable.dart';

class LoginCubitState extends Equatable {
  final LoginEntity? entity;
  final bool isPasswordObscured;

  const LoginCubitState({
    required this.entity,
    this.isPasswordObscured = true,
  });

  LoginCubitState copyWith({
    LoginEntity? entity,
    bool? isPasswordObscured,
  }) {
    return LoginCubitState(
      entity: entity ?? this.entity,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
    );
  }

  @override
  List<Object?> get props => [entity, isPasswordObscured];
}