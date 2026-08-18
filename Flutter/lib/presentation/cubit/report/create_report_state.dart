import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:equatable/equatable.dart';

class CreateReportCubitState extends Equatable {
  final CreateReportEntity? entity;
  const CreateReportCubitState({this.entity});

  CreateReportCubitState copyWith({CreateReportEntity? entity}) {
    return CreateReportCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}