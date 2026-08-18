
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

class GetDepositRequestsCubitState extends Equatable {
  final RidesNoParamsEntity entity;

  const GetDepositRequestsCubitState({this.entity = const RidesNoParamsEntity()});

  GetDepositRequestsCubitState copyWith({RidesNoParamsEntity? entity}) {
    return GetDepositRequestsCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}