import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IMyRidesEvent extends Equatable {
  const IMyRidesEvent();
}

final class GetMyRidesEvent extends IMyRidesEvent {
  final RidesNoParamsEntity entity;

  const GetMyRidesEvent({this.entity = const RidesNoParamsEntity()});

  @override
  List<Object?> get props => [entity];
}