import 'package:flutter/foundation.dart';

// الكلاس الأساسي المجرد لحالات تسجيل الدخول
@immutable
abstract class LoginState {}

// الحالة الأولية عند فتح الشاشة
class LoginInitialState extends LoginState {}

// حالة تغيير إظهار/إخفاء كلمة المرور
class LoginPasswordVisibilityChangedState extends LoginState {
  final bool isObscured;

  LoginPasswordVisibilityChangedState(this.isObscured);
}

// حالة بدء تحميل طلب تسجيل الدخول
class LoginLoadingState extends LoginState {}

// حالة نجاح تسجيل الدخول
class LoginSuccessState extends LoginState {}

// حالة حدوث خطأ أثناء تسجيل الدخول
class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}