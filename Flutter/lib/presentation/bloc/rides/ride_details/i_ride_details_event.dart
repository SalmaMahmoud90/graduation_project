import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IRideDetailsEvent extends Equatable {
  const IRideDetailsEvent();
}

final class GetRideDetailsEvent extends IRideDetailsEvent {
  final IdEntity entity;

  const GetRideDetailsEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}