import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';

// واجهة مستودع المحفظة والمدفوعات
abstract interface class IPaymentRepository {
  Future<Either<AppException, BaseModel<WalletBalanceModel>?>> getBalance(
      RidesNoParamsEntity data);
  Future<Either<AppException, BaseModel<DepositRequestDataModel>?>>
      createDepositRequest(CreateDepositRequestEntity data);
  Future<Either<AppException, BaseModel<DepositRequestsListModel>?>>
      getDepositRequests(RidesNoParamsEntity data);
  Future<Either<AppException, BaseModel<TransactionsListModel>?>>
      getTransactions(RidesNoParamsEntity data);
  Future<Either<AppException, BaseModel<PayResponseModel>?>> payReservation(
      PayReservationEntity data);
}