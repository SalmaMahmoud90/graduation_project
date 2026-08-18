
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

class GetSharedRidesCubitState extends Equatable {
  final IdEntity? entity;

  const GetSharedRidesCubitState({this.entity});

  GetSharedRidesCubitState copyWith({IdEntity? entity}) {
    return GetSharedRidesCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}