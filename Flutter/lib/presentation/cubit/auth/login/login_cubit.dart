import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

// كيوبيت إدارة عملية وتسجيل الدخول
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  // متغيرات حالة الواجهة المحلية
  bool isPasswordObscured = true;
  bool isLoading = false;

  // دالة التبديل بين إظهار وإخفاء كلمة المرور
  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    emit(LoginPasswordVisibilityChangedState(isPasswordObscured));
  }

  // دالة تنفيذ عملية تسجيل الدخول
  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    emit(LoginLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      emit(LoginSuccessState());
    } catch (e) {
      isLoading = false;
      emit(LoginErrorState(e.toString()));
    }
  }
}