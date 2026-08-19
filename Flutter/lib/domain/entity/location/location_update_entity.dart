import 'package:equatable/equatable.dart';

class LocationUpdateEntity extends Equatable {
  final int? userId;
  final double latitude;
  final double longitude;
  final String? recordedAt;

  const LocationUpdateEntity({
    this.userId,
    required this.latitude,
    required this.longitude,
    this.recordedAt,
  });

  @override
  List<Object?> get props => [userId, latitude, longitude, recordedAt];
}