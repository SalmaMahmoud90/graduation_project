import 'package:a_tareqaak/domain/repository/payment/_payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<BaseModel<TransactionsListModel>?, RidesNoParamsEntity>)
@Named('GetTransactionsUseCase')
class GetTransactionsUseCase
    implements IUseCase<BaseModel<TransactionsListModel>?, RidesNoParamsEntity> {
  final IPaymentRepository _repository;
  GetTransactionsUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<TransactionsListModel>?>> call(
          RidesNoParamsEntity data) =>
      _repository.getTransactions(data);
}
