
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

class GetTransactionsCubitState extends Equatable {
  final RidesNoParamsEntity entity;

  const GetTransactionsCubitState({this.entity = const RidesNoParamsEntity()});

  GetTransactionsCubitState copyWith({RidesNoParamsEntity? entity}) {
    return GetTransactionsCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}