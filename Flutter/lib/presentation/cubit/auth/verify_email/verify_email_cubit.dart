import 'dart:async';
import 'package:a_tareqaak/presentation/cubit/auth/verify_email/verify_email_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';

// كيوبيت نموذج إدخال كود التحقق والمؤقت الزمني
class VerifyEmailCubit extends Cubit<VerifyEmailCubitState> {
  Timer? _timer;

  VerifyEmailCubit(String email)
      : super(VerifyEmailCubitState(
          entity: VerifyEmailEntity(email: email, code: ''),
        )) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    emit(state.copyWith(timerSeconds: 45, canResend: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerSeconds > 1) {
        emit(state.copyWith(timerSeconds: state.timerSeconds - 1));
      } else {
        _timer?.cancel();
        emit(state.copyWith(timerSeconds: 0, canResend: true));
      }
    });
  }

void codeChanged(int index, String value) {
  final current =
      state.entity ?? const VerifyEmailEntity(email: '', code: '');

  final code = current.code.padRight(6, ' ').split('');

  code[index] = value.isEmpty ? ' ' : value;

  final newCode = code.join().trim();

  emit(
    state.copyWith(
      entity: VerifyEmailEntity(
        email: current.email,
        code: newCode,
      ),
    ),
  );
}
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}