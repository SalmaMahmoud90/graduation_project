import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_model.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class BaseModel<T> extends Equatable {
  const BaseModel({
    this.success,
    this.message,
    this.code,
    this.isArchived,
    this.data,
    this.error,
  });

  final bool? success;
  final String? message;
  final String? code;
  @JsonKey(name: 'is_archived')
  final bool? isArchived;
  final T? data;
  final String? error;

  factory BaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    debugPrint("json in base model $json");
    return _$BaseModelFromJson(json, fromJsonT);
  }

  @override
  List<Object?> get props => [
        success,
        message,
        code,
        isArchived,
        data,
        error,
      ];
}