import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/constants/api_endpoints.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/data_source/base/base_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/report/report_entity.dart';

@Injectable()
class ReportRemoteDataSource extends BaseRemoteDataSource<dynamic> {
  ReportRemoteDataSource() : super(ApiEndpoints.report);

  // 1. إنشاء بلاغ ضد مستخدم (POST /api/reports/report/user/<user_id>/)
  Future<Either<AppException, BaseModel<ReportDataModel>?>> createReport(
      CreateReportEntity data) {
    return postData<ReportDataModel>(
      endpoint: ApiEndpoints.reportUser(data.userId),
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          ReportDataModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 2. جلب الرحلات المشتركة مع المستخدم (GET /api/reports/shared_rides/<user_id>/)
  Future<Either<AppException, BaseModel<RidesListModel>?>> getSharedRides(
      IdEntity data) {
    return fetchData<RidesListModel>(
      endpoint: ApiEndpoints.shareRides(data.id),
      fromJsonT: (json) =>
          RidesListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 3. عرض جميع بلاغات المستخدم (GET /api/reports/my_reports/)
  Future<Either<AppException, BaseModel<ReportsListModel>?>> getMyReports() {
    return fetchData<ReportsListModel>(
      endpoint: ApiEndpoints.myReports,
      fromJsonT: (json) =>
          ReportsListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 4. عرض تفاصيل بلاغ محدد (GET /api/reports/view_report_details/<report_id>/)
  Future<Either<AppException, BaseModel<ReportDataModel>?>> getReportDetails(
      IdEntity data) {
    return fetchData<ReportDataModel>(
      endpoint: '/view_report_details/${data.id}/',
      fromJsonT: (json) =>
          ReportDataModel.fromJson(json as Map<String, dynamic>),
    );
  }
}