

import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IGetTransactionsEvent extends Equatable {
  const IGetTransactionsEvent();
}

final class GetTransactionsEvent extends IGetTransactionsEvent {
  final RidesNoParamsEntity entity;

  const GetTransactionsEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}