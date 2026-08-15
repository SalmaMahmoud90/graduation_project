import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ICancelRideEvent extends Equatable {
  const ICancelRideEvent();
}

final class CancelRideEvent extends ICancelRideEvent {
  final IdEntity entity;

  const CancelRideEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}