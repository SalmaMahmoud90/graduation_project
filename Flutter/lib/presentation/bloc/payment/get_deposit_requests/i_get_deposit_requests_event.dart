

import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IGetDepositRequestsEvent extends Equatable {
  const IGetDepositRequestsEvent();
}

final class GetDepositRequestsEvent extends IGetDepositRequestsEvent {
  final RidesNoParamsEntity entity;

  const GetDepositRequestsEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}