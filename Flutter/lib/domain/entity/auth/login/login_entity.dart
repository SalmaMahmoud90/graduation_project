import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String email;
  final String password;

  const LoginEntity({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };

  Map<String, dynamic> toLoginJson() => toJson(); // 👈 إضافة هاد السطر

  @override
  List<Object?> get props => [email, password];
}