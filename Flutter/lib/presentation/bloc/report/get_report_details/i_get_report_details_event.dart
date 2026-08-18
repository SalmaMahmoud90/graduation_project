import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IGetReportDetailsEvent extends Equatable {
  const IGetReportDetailsEvent();
}

final class GetReportDetailsEvent extends IGetReportDetailsEvent {
  final IdEntity entity;

  const GetReportDetailsEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}
