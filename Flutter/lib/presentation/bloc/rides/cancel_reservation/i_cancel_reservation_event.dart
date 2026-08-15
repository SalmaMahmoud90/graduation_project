
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ICancelReservationEvent extends Equatable {
  const ICancelReservationEvent();
}

final class CancelReservationEvent extends ICancelReservationEvent {
  final IdEntity entity;

  const CancelReservationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}