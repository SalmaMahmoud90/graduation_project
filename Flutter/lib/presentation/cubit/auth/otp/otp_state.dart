import 'package:flutter/foundation.dart';

// الكلاس الأساسي المجرد لحالات رمز التحقق
@immutable
abstract class OtpState {}

// الحالة الأولية للشاشة
class OtpInitialState extends OtpState {}

// حالة تحديث العد التنازلي لمؤقت إعادة الإرسال
class OtpTimerTickState extends OtpState {
  final int seconds;
  final bool canResend;

  OtpTimerTickState({
    required this.seconds,
    required this.canResend,
  });
}

// حالة تغيير أحد أرقام الرمز أدخلها المستخدم
class OtpCodeUpdatedState extends OtpState {
  final List<String> digits;
  final bool isComplete;

  OtpCodeUpdatedState({
    required this.digits,
    required this.isComplete,
  });
}

// حالة بدء التحقق من الرمز
class OtpLoadingState extends OtpState {}

// حالة نجاح صحة الرمز
class OtpSuccessState extends OtpState {}

// حالة خطأ في الرمز أو الفشل في إرساله
class OtpErrorState extends OtpState {
  final String message;

  OtpErrorState(this.message);
}