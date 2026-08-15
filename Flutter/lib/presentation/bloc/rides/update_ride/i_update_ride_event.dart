import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IUpdateRideEvent extends Equatable {
  const IUpdateRideEvent();
}

final class UpdateRideEvent extends IUpdateRideEvent {
  final UpdateRideEntity entity;

  const UpdateRideEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}