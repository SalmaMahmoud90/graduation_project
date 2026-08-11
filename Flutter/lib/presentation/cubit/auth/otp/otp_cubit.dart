import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_state.dart';

// كيوبيت إدارة رمز التحقق OTP والمؤقت الزمني
class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitialState()) {
    startTimer();
  }

  Timer? _timer;
  int timerSeconds = 45;
  bool canResend = false;
  bool isLoading = false;
  List<String> otpDigits = ['', '', '', '', ''];

  // خاصية للتحقق مما إذا كان الرمز مكتمل الخانات (5 أرقام)
  bool get isCodeComplete => otpDigits.every((digit) => digit.isNotEmpty);

  // دالة تشغيل مؤقت العد التنازلي لإعادة الإرسال
  void startTimer() {
    _timer?.cancel();
    timerSeconds = 45;
    canResend = false;
    emit(OtpTimerTickState(seconds: timerSeconds, canResend: canResend));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 1) {
        timerSeconds--;
        emit(OtpTimerTickState(seconds: timerSeconds, canResend: false));
      } else {
        _timer?.cancel();
        timerSeconds = 0;
        canResend = true;
        emit(OtpTimerTickState(seconds: 0, canResend: true));
      }
    });
  }

  // تحديث خانة معينة في رمز الـ OTP
  void updateDigit(int index, String digit) {
    otpDigits[index] = digit;
    emit(OtpCodeUpdatedState(digits: List.from(otpDigits), isComplete: isCodeComplete));
  }

  // إعادة إرسال الرمز وإعادة تشغيل المؤقت
  void resendCode() {
    if (canResend) {
      startTimer();
    }
  }

  // التأكد من صحة الرمز عبر API
  Future<void> verifyCode() async {
    isLoading = true;
    emit(OtpLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      emit(OtpSuccessState());
    } catch (e) {
      isLoading = false;
      emit(OtpErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}