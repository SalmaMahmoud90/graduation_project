import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:a_tareqaak/domain/entity/location/ride_tracking_connection_entity.dart';
import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:equatable/equatable.dart';


sealed class IRideTrackingEvent extends Equatable {
  const IRideTrackingEvent();
}

final class ConnectToRideTrackingEvent extends IRideTrackingEvent {
  final RideTrackingConnectionEntity entity;

  const ConnectToRideTrackingEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

final class SendDriverLocationEvent extends IRideTrackingEvent {
  final SendLocationEntity entity;

  const SendDriverLocationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

final class OnLocationReceivedInternalEvent extends IRideTrackingEvent {
  final LocationUpdateEntity entity;

  const OnLocationReceivedInternalEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

final class DisconnectFromRideTrackingEvent extends IRideTrackingEvent {
  const DisconnectFromRideTrackingEvent();

  @override
  List<Object?> get props => [];
}