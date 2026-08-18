import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/data_source/report/report_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/repository/report/i_report_repository.dart';

@Injectable(as: IReportRepository)
class ReportRepository implements IReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepository(this._remoteDataSource);

  @override
  Future<Either<AppException, BaseModel<ReportDataModel>?>> createReport(
          CreateReportEntity data) =>
      _remoteDataSource.createReport(data);

  @override
  Future<Either<AppException, BaseModel<RidesListModel>?>> getSharedRides(
         IdEntity data) =>
      _remoteDataSource.getSharedRides(data);

  @override
  Future<Either<AppException, BaseModel<ReportsListModel>?>> getMyReports(
          RidesNoParamsEntity data) =>
      _remoteDataSource.getMyReports();

  @override
  Future<Either<AppException, BaseModel<ReportDataModel>?>> getReportDetails(
          IdEntity data) =>
      _remoteDataSource.getReportDetails(data);
}