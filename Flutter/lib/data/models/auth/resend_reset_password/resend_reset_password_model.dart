import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resend_reset_password_model.g.dart';

// مودل استجابة نسيت كلمة المرور
@JsonSerializable(createToJson: false)
class ResendResetPasswordModel extends Equatable {
  
  @JsonKey(name: 'reset_token')
  final String? resetToken;

  const ResendResetPasswordModel({
    
    this.resetToken,
  });

  factory ResendResetPasswordModel.fromJson(Map<String, dynamic> json) {
    
    return _$ResendResetPasswordModelFromJson(json);
  }

  @override
  List<Object?> get props => [resetToken];
}