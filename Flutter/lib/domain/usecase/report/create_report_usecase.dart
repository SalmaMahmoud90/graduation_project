import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/repository/report/i_report_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<BaseModel<ReportDataModel>?, CreateReportEntity>)
@Named('CreateReportUseCase')
class CreateReportUseCase
    implements IUseCase<BaseModel<ReportDataModel>?, CreateReportEntity> {
  final IReportRepository _repository;
  CreateReportUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<ReportDataModel>?>> call(
          CreateReportEntity data) =>
      _repository.createReport(data);
}