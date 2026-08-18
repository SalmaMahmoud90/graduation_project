import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/repository/report/i_report_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<BaseModel<ReportDataModel>?, IdEntity>)
@Named('GetReportDetailsUseCase')
class GetReportDetailsUseCase
    implements IUseCase<BaseModel<ReportDataModel>?, IdEntity> {
  final IReportRepository _repository;
  GetReportDetailsUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<ReportDataModel>?>> call(
          IdEntity data) =>
      _repository.getReportDetails(data);
}