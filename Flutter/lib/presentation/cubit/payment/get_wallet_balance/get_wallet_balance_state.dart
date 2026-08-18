
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

class GetWalletBalanceCubitState extends Equatable {
  final RidesNoParamsEntity entity;

  const GetWalletBalanceCubitState({this.entity = const RidesNoParamsEntity()});

  GetWalletBalanceCubitState copyWith({RidesNoParamsEntity? entity}) {
    return GetWalletBalanceCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}