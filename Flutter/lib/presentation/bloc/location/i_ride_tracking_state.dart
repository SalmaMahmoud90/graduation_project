import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IRideTrackingState extends Equatable {
  const IRideTrackingState();
}

final class RideTrackingInitial extends IRideTrackingState {
  @override
  List<Object?> get props => [];
}

final class RideTrackingConnecting extends IRideTrackingState {
  @override
  List<Object?> get props => [];
}

final class RideTrackingConnected extends IRideTrackingState {
  @override
  List<Object?> get props => [];
}

final class RideTrackingLocationReceived extends IRideTrackingState {
  final LocationUpdateEntity location;

  const RideTrackingLocationReceived(this.location);

  @override
  List<Object?> get props => [location];
}

final class RideTrackingDisconnected extends IRideTrackingState {
  @override
  List<Object?> get props => [];
}

final class RideTrackingFailed extends IRideTrackingState {
  final String message;

  const RideTrackingFailed(this.message);

  @override
  List<Object?> get props => [message];
}