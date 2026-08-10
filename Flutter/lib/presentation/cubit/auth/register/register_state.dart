import 'package:flutter/foundation.dart';
import 'package:a_tareqaak/core/utils/enums/enum_utils.dart';

// الكلاس الأساسي المجرد لحالات إنشاء الحساب
@immutable
abstract class RegisterState {}

// الحالة الأولية للشاشة
class RegisterInitialState extends RegisterState {}

// حالة تغيير اختيار الدور (سائق / راكب)
class RegisterRoleChangedState extends RegisterState {
  final UserType? selectedRole;

  RegisterRoleChangedState(this.selectedRole);
}

// حالة تغيير إظهار/إخفاء كلمة المرور الرئيسية
class RegisterPasswordVisibilityChangedState extends RegisterState {
  final bool isObscured;

  RegisterPasswordVisibilityChangedState(this.isObscured);
}

// حالة تغيير إظهار/إخفاء تأكيد كلمة المرور
class RegisterConfirmPasswordVisibilityChangedState extends RegisterState {
  final bool isObscured;

  RegisterConfirmPasswordVisibilityChangedState(this.isObscured);
}

// حالة تغيير الموافقة على الشروط والأحكام
class RegisterTermsChangedState extends RegisterState {
  final bool isAccepted;

  RegisterTermsChangedState(this.isAccepted);
}

// حالة تحميل طلب إنشاء الحساب
class RegisterLoadingState extends RegisterState {}

// حالة نجاح إنشاء الحساب مع إرجاع نوع المستخدم المختار للتوجيه
class RegisterSuccessState extends RegisterState {
  final UserType role;

  RegisterSuccessState(this.role);
}

// حالة حدوث خطأ أثناء إنشاء الحساب
class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}