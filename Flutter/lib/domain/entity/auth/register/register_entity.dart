import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;
  final String userType;

  const RegisterEntity({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "password": password,
        "confirm_password": confirmPassword,
        "user_type": userType,
      };

  Map<String, dynamic> toRegisterJson() => toJson(); // 👈 إضافة هاد السطر

  @override
  List<Object?> get props => [email, name, password, confirmPassword, userType];
}