import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resend_reset_code_model.g.dart';

// مودل استجابة نسيت كلمة المرور
@JsonSerializable(createToJson: false)
class ResendResetCodeModel extends Equatable {
  
  @JsonKey(name: 'reset_token')
  final String? resetToken;

  const ResendResetCodeModel({
    
    this.resetToken,
  });

  factory ResendResetCodeModel.fromJson(Map<String, dynamic> json) {
    
    return _$ResendResetCodeModelFromJson(json);
  }

  @override
  List<Object?> get props => [resetToken];
}