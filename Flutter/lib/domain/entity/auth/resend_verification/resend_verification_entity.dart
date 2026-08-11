import 'package:equatable/equatable.dart';

// كيان بيانات إعادة إرسال رمز التحقق
class ResendVerificationEntity extends Equatable {
  final String email;

  const ResendVerificationEntity({required this.email});

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  List<Object?> get props => [email];
}