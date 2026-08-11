// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensModel _$TokensModelFromJson(Map<String, dynamic> json) => TokensModel(
  accessToken: json['access_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  tokenType: json['token_type'] as String?,
  expiresIn: (json['expires_in'] as num?)?.toInt(),
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
);
