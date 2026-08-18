
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:equatable/equatable.dart';

class GetMyReportsCubitState extends Equatable {
  final RidesNoParamsEntity entity;

  const GetMyReportsCubitState({this.entity = const RidesNoParamsEntity()});

  GetMyReportsCubitState copyWith({RidesNoParamsEntity? entity}) {
    return GetMyReportsCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}