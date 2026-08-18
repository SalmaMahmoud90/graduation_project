import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';

// واجهة مستودع البلاغات
abstract interface class IReportRepository {
  Future<Either<AppException, BaseModel<ReportDataModel>?>> createReport(
      CreateReportEntity data);
  Future<Either<AppException, BaseModel<RidesListModel>?>> getSharedRides(
      IdEntity data);
  Future<Either<AppException, BaseModel<ReportsListModel>?>> getMyReports(
      RidesNoParamsEntity data);
  Future<Either<AppException, BaseModel<ReportDataModel>?>> getReportDetails(
      IdEntity data);
}