// lib/presentation/cubit/reports/reports_state.dart
import 'package:a_tareqaak/data/models/report/report_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ReportsState {}

class ReportsInitialState extends ReportsState {}

class ReportsLoadingState extends ReportsState {}

class ReportsLoadedState extends ReportsState {
  final List<ReportModel> reports;
  ReportsLoadedState(this.reports);
}

class SendReportSuccessState extends ReportsState {}

class ReportsErrorState extends ReportsState {
  final String message;
  ReportsErrorState(this.message);
}