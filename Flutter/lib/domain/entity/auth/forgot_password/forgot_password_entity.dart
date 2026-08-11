import 'package:equatable/equatable.dart';

// كيان طلب نسيت كلمة المرور
class ForgotPasswordEntity extends Equatable {
  final String email;

  const ForgotPasswordEntity({required this.email});

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  List<Object?> get props => [email];
}