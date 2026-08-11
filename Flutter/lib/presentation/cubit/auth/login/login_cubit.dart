import 'package:a_tareqaak/presentation/cubit/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';



// كيوبيت إدارة مدخلات نموذج تسجيل الدخول
class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(const LoginCubitState(entity: null));

  // تحديث البريد في الـ Entity
  void emailChanged(String email) {
    final currentEntity = state.entity ?? const LoginEntity(email: '', password: '');
    emit(
      state.copyWith(
        entity: LoginEntity(
          email: email,
          password: currentEntity.password,
        ),
      ),
    );
  }

  // تحديث كلمة المرور في الـ Entity
  void passwordChanged(String password) {
    final currentEntity = state.entity ?? const LoginEntity(email: '', password: '');
    emit(
      state.copyWith(
        entity: LoginEntity(
          email: currentEntity.email,
          password: password,
        ),
      ),
    );
  }

  // تبديل إظهار/إخفاء كلمة المرور
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }
}