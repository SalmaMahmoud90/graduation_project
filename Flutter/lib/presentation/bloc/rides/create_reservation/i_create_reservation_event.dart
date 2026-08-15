import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateReservationEvent extends Equatable {
  const ICreateReservationEvent();
}

final class CreateReservationEvent extends ICreateReservationEvent {
  final CreateReservationEntity entity;

  const CreateReservationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}