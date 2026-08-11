import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokens_model.g.dart';

// مودل Tokens الـ OAuth مع بيانات المستخدم
@JsonSerializable(createToJson: false)
class TokensModel extends Equatable {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  final UserModel? user;

  const TokensModel({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        user,
      ];
}