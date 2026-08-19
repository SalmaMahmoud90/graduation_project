// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdateModel _$LocationUpdateModelFromJson(Map<String, dynamic> json) =>
    LocationUpdateModel(
      type: json['type'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: json['recorded_at'] as String?,
    );
