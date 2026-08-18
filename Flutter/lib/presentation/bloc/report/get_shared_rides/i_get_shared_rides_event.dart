
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IGetSharedRidesEvent extends Equatable {
  const IGetSharedRidesEvent();
}

final class GetSharedRidesEvent extends IGetSharedRidesEvent {
  final IdEntity entity;

  const GetSharedRidesEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}