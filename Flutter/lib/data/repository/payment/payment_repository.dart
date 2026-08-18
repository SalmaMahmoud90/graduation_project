import 'package:a_tareqaak/domain/repository/payment/_payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/data_source/payment/payment_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';

@Injectable(as: IPaymentRepository)
class PaymentRepository implements IPaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepository(this._remoteDataSource);

  @override
  Future<Either<AppException, BaseModel<WalletBalanceModel>?>> getBalance(
          RidesNoParamsEntity data) =>
      _remoteDataSource.getBalance();

  @override
  Future<Either<AppException, BaseModel<DepositRequestDataModel>?>>
      createDepositRequest(CreateDepositRequestEntity data) =>
          _remoteDataSource.createDepositRequest(data);

  @override
  Future<Either<AppException, BaseModel<DepositRequestsListModel>?>>
      getDepositRequests(RidesNoParamsEntity data) =>
          _remoteDataSource.getDepositRequests();

  @override
  Future<Either<AppException, BaseModel<TransactionsListModel>?>>
      getTransactions(RidesNoParamsEntity data) =>
          _remoteDataSource.getTransactions();

  @override
  Future<Either<AppException, BaseModel<PayResponseModel>?>> payReservation(
          PayReservationEntity data) =>
      _remoteDataSource.payReservation(data);
}