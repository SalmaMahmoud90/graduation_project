
// حالة الكيوبيت لإدخال كود التحقق والمؤقت
import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';
import 'package:equatable/equatable.dart';

class VerifyEmailCubitState extends Equatable {
  final VerifyEmailEntity? entity;
  final int timerSeconds;
  final bool canResend;

  const VerifyEmailCubitState({
    required this.entity,
    this.timerSeconds = 45,
    this.canResend = false,
  });

  VerifyEmailCubitState copyWith({
    VerifyEmailEntity? entity,
    int? timerSeconds,
    bool? canResend,
  }) {
    return VerifyEmailCubitState(
      entity: entity ?? this.entity,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      canResend: canResend ?? this.canResend,
    );
  }

  @override
  List<Object?> get props => [entity, timerSeconds, canResend];
}