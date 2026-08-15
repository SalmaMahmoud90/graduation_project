import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IReservationActionEvent extends Equatable {
  const IReservationActionEvent();
}

final class AcceptReservationEvent extends IReservationActionEvent {
  final IdEntity entity;

  const AcceptReservationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

final class RejectReservationEvent extends IReservationActionEvent {
  final IdEntity entity;

  const RejectReservationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}