import 'package:equatable/equatable.dart';

class ResetPasswordEntity extends Equatable {
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordEntity({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        "reset_token": resetToken,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };

  Map<String, dynamic> toResetPasswordJson() => toJson(); // 👈 إضافة هاد السطر

  @override
  List<Object?> get props => [resetToken, newPassword, confirmPassword];
}