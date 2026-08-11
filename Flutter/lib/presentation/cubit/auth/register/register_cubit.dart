import 'package:a_tareqaak/presentation/cubit/auth/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';


// كيوبيت إدارة مدخلات نموذج إنشاء الحساب
class RegisterCubit extends Cubit<RegisterCubitState> {
  RegisterCubit() : super(const RegisterCubitState(entity: null));

  void nameChanged(String name) {
    _updateEntity(name: name);
  }

  void emailChanged(String email) {
    _updateEntity(email: email);
  }

  void passwordChanged(String password) {
    _updateEntity(password: password);
  }

  void confirmPasswordChanged(String confirmPassword) {
    _updateEntity(confirmPassword: confirmPassword);
  }

  void userTypeChanged(String userType) {
    _updateEntity(userType: userType);
  }

  void _updateEntity({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? userType,
  }) {
    final current = state.entity ??
        const RegisterEntity(
          email: '',
          name: '',
          password: '',
          confirmPassword: '',
          userType: 'driver',
        );

    emit(
      state.copyWith(
        entity: RegisterEntity(
          email: email ?? current.email,
          name: name ?? current.name,
          password: password ?? current.password,
          confirmPassword: confirmPassword ?? current.confirmPassword,
          userType: userType ?? current.userType,
        ),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }

  void toggleTerms(bool? accepted) {
    emit(state.copyWith(isTermsAccepted: accepted ?? false));
  }
}