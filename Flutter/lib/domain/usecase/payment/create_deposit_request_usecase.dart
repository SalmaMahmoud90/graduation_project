import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/domain/repository/payment/_payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(
    as: IUseCase<BaseModel<DepositRequestDataModel>?,
        CreateDepositRequestEntity>)
@Named('CreateDepositRequestUseCase')
class CreateDepositRequestUseCase
    implements
        IUseCase<BaseModel<DepositRequestDataModel>?,
            CreateDepositRequestEntity> {
  final IPaymentRepository _repository;
  CreateDepositRequestUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<DepositRequestDataModel>?>> call(
          CreateDepositRequestEntity data) =>
      _repository.createDepositRequest(data);
}