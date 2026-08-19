import 'package:equatable/equatable.dart';

class RideTrackingConnectionEntity extends Equatable {
  final int rideId;
  final String? token;

  const RideTrackingConnectionEntity({
    required this.rideId,
    this.token,
  });

  @override
  List<Object?> get props => [rideId, token];
}