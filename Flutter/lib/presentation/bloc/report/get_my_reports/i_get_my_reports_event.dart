
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IGetMyReportsEvent extends Equatable {
  const IGetMyReportsEvent();
}

final class GetMyReportsEvent extends IGetMyReportsEvent {
  final RidesNoParamsEntity entity;

  const GetMyReportsEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}