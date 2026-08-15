import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateRideEvent extends Equatable {
  const ICreateRideEvent();
}

final class CreateRideEvent extends ICreateRideEvent {
  final CreateRideEntity entity;

  const CreateRideEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}