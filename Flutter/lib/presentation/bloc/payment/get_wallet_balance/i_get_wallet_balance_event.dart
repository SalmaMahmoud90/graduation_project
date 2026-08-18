
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IGetWalletBalanceEvent extends Equatable {
  const IGetWalletBalanceEvent();
}

final class GetWalletBalanceEvent extends IGetWalletBalanceEvent {
  final RidesNoParamsEntity entity;

  const GetWalletBalanceEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}