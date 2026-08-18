import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/domain/repository/payment/_payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<BaseModel<PayResponseModel>?, PayReservationEntity>)
@Named('PayReservationUseCase')
class PayReservationUseCase
    implements IUseCase<BaseModel<PayResponseModel>?, PayReservationEntity> {
  final IPaymentRepository _repository;
  PayReservationUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<PayResponseModel>?>> call(
          PayReservationEntity data) =>
      _repository.payReservation(data);
}