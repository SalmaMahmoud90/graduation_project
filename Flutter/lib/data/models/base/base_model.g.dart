// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel<T> _$BaseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseModel<T>(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  code: json['code'] as String?,
  isArchived: json['is_archived'] as bool?,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  error: json['error'] as String?,
);

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);
