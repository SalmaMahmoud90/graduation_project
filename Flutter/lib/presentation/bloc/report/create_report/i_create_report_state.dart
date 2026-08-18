
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateReportState extends Equatable {
  const ICreateReportState();
}

final class CreateReportInitial extends ICreateReportState {
  @override
  List<Object> get props => [];
}

final class CreateReportLoading extends ICreateReportState {
  @override
  List<Object> get props => [];
}

final class CreateReportLoaded extends ICreateReportState {
  final BaseModel<ReportDataModel>? responseModel;
  const CreateReportLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class CreateReportFailed extends ICreateReportState {
  final String message;
  const CreateReportFailed(this.message);

  @override
  List<Object> get props => [message];
}