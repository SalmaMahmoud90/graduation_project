import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class IGetReportDetailsState extends Equatable {
  const IGetReportDetailsState();
}

final class GetReportDetailsInitial extends IGetReportDetailsState {
  @override
  List<Object> get props => [];
}

final class GetReportDetailsLoading extends IGetReportDetailsState {
  @override
  List<Object> get props => [];
}

final class GetReportDetailsLoaded extends IGetReportDetailsState {
  final BaseModel<ReportDataModel>? responseModel;

  const GetReportDetailsLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class GetReportDetailsFailed extends IGetReportDetailsState {
  final String message;

  const GetReportDetailsFailed(this.message);

  @override
  List<Object> get props => [message];
}
