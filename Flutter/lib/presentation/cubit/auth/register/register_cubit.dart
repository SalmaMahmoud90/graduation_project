import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/utils/enums/enum_utils.dart';
import 'register_state.dart';

// كيوبيت إدارة عملية إنشاء حساب جديد
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  // متغيرات الواجهة المحلية
  UserType? selectedRole;
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isTermsAccepted = false;
  bool isLoading = false;

  // اختيار الدور (سائق أم راكب)
  void selectRole(UserType? role) {
    selectedRole = role;
    emit(RegisterRoleChangedState(selectedRole));
  }

  // تبديل رؤية كلمة المرور
  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    emit(RegisterPasswordVisibilityChangedState(isPasswordObscured));
  }

  // تبديل رؤية تأكيد كلمة المرور
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured = !isConfirmPasswordObscured;
    emit(RegisterConfirmPasswordVisibilityChangedState(isConfirmPasswordObscured));
  }

  // تبديل حالة الموافقة على الشروط والأحكام
  void toggleTerms(bool? value) {
    isTermsAccepted = value ?? false;
    emit(RegisterTermsChangedState(isTermsAccepted));
  }

  // دالة إرسال بيانات الحساب الجديد
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required UserType role,
  }) async {
    isLoading = true;
    emit(RegisterLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      // إرسال النجاح مع الدور المحدد لتوجيه المستخدم للهوم المناسب
      emit(RegisterSuccessState(role));
    } catch (e) {
      isLoading = false;
      emit(RegisterErrorState(e.toString()));
    }
  }
}