import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response_model.g.dart';

// مودل استجابة نسيت كلمة المرور
@JsonSerializable(createToJson: false)
class ForgotPasswordResponseModel extends Equatable {
  final String? message;
  final String? email;
  @JsonKey(name: 'reset_token')
  final String? resetToken;

  const ForgotPasswordResponseModel({
    this.message,
    this.email,
    this.resetToken,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    debugPrint("json  in forgot model $json");
    return _$ForgotPasswordResponseModelFromJson(json);
  }

  @override
  List<Object?> get props => [message, email, resetToken];
}