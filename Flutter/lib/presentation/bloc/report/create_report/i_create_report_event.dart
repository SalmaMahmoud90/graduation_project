import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateReportEvent extends Equatable {
  const ICreateReportEvent();
}

final class CreateReportEvent extends ICreateReportEvent {
  final CreateReportEntity entity;
  const CreateReportEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}