import 'package:equatable/equatable.dart';

// كيان بيانات إعادة إرسال رمز التحقق
class ResendResetCodeEntity extends Equatable {
  final String resetToken;

  const ResendResetCodeEntity({required this.resetToken});

  Map<String, dynamic> toJson() => {
        "reset_token":resetToken,
      };

  @override
  List<Object?> get props => [resetToken];
}