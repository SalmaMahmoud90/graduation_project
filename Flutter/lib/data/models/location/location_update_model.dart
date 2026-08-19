import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_update_model.g.dart';

@JsonSerializable(createToJson: false)
class LocationUpdateModel extends Equatable {
  final String? type;
  @JsonKey(name: 'user_id')
  final int? userId;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'recorded_at')
  final String? recordedAt;

  const LocationUpdateModel({
    this.type,
    this.userId,
    required this.latitude,
    required this.longitude,
    this.recordedAt,
  });

  factory LocationUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateModelFromJson(json);

  LocationUpdateEntity toEntity() => LocationUpdateEntity(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        recordedAt: recordedAt,
      );

  @override
  List<Object?> get props => [type, userId, latitude, longitude, recordedAt];
}