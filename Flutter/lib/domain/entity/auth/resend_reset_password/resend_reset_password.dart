import 'package:equatable/equatable.dart';

// كيان بيانات إعادة إرسال رمز التحقق
class ResendResetPasswordEntity extends Equatable {
  final String resetToken;

  const ResendResetPasswordEntity({required this.resetToken});

  Map<String, dynamic> toJson() => {
        "reset_token":resetToken,
      };

  @override
  List<Object?> get props => [resetToken];
}