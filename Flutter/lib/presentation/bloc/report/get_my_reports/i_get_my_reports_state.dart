
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class IGetMyReportsState extends Equatable {
  const IGetMyReportsState();
}

final class GetMyReportsInitial extends IGetMyReportsState {
  @override
  List<Object> get props => [];
}

final class GetMyReportsLoading extends IGetMyReportsState {
  @override
  List<Object> get props => [];
}

final class GetMyReportsLoaded extends IGetMyReportsState {
  final BaseModel<ReportsListModel>? responseModel;

  const GetMyReportsLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class GetMyReportsFailed extends IGetMyReportsState {
  final String message;

  const GetMyReportsFailed(this.message);

  @override
  List<Object> get props => [message];
}