import 'package:equatable/equatable.dart';

class VerifyResetCodeEntity extends Equatable {
  final String resetToken;
  final String code;

  const VerifyResetCodeEntity({
    required this.resetToken,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        "reset_token": resetToken,
        "code": code,
      };

  Map<String, dynamic> toVerifyResetCodeJson() => toJson(); // 👈 إضافة هاد السطر

  @override
  List<Object?> get props => [resetToken, code];
}