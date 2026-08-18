import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/repository/report/i_report_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<BaseModel<ReportsListModel>?, RidesNoParamsEntity>)
@Named('GetMyReportsUseCase')
class GetMyReportsUseCase
    implements IUseCase<BaseModel<ReportsListModel>?, RidesNoParamsEntity> {
  final IReportRepository _repository;
  GetMyReportsUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<ReportsListModel>?>> call(
          RidesNoParamsEntity data) =>
      _repository.getMyReports(data);
}