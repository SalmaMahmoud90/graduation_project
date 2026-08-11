import 'package:equatable/equatable.dart';

class VerifyEmailEntity extends Equatable {
  final String email;
  final String code;

  const VerifyEmailEntity({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "code": code,
      };

  Map<String, dynamic> toVerifyEmailJson() => toJson(); // 👈 إضافة هاد السطر

  @override
  List<Object?> get props => [email, code];
}