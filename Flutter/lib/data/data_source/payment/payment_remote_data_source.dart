import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/constants/api_endpoints.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/data/data_source/base/base_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';

@Injectable()
class PaymentRemoteDataSource extends BaseRemoteDataSource<dynamic> {
  PaymentRemoteDataSource() : super(ApiEndpoints.payments);

  // 1. عرض رصيد المحفظة (GET /api/payments/view_balance/)
  Future<Either<AppException, BaseModel<WalletBalanceModel>?>> getBalance() {
    return fetchData<WalletBalanceModel>(
      endpoint: ApiEndpoints.viewBalance,
      fromJsonT: (json) =>
          WalletBalanceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 2. إنشاء طلب إيداع رصيد (POST /api/payments/deposit_request/)
  Future<Either<AppException, BaseModel<DepositRequestDataModel>?>>
      createDepositRequest(CreateDepositRequestEntity data) {
    return postData<DepositRequestDataModel>(
      endpoint: ApiEndpoints.depositeRequest,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          DepositRequestDataModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 3. عرض طلبات الإيداع للراكب (GET /api/payments/view_deposit_requests/)
  Future<Either<AppException, BaseModel<DepositRequestsListModel>?>>
      getDepositRequests() {
    return fetchData<DepositRequestsListModel>(
      endpoint: ApiEndpoints.viewDepositeRequests,
      fromJsonT: (json) =>
          DepositRequestsListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 4. عرض سجل المعاملات المالية (GET /api/payments/view_transactions/)
  Future<Either<AppException, BaseModel<TransactionsListModel>?>>
      getTransactions() {
    return fetchData<TransactionsListModel>(
      endpoint: ApiEndpoints.viewTransaction,
      fromJsonT: (json) =>
          TransactionsListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 5. دفع قيمة حجز (POST /api/payments/pay/)
  Future<Either<AppException, BaseModel<PayResponseModel>?>> payReservation(
      PayReservationEntity data) {
    return postData<PayResponseModel>(
      endpoint: ApiEndpoints.pay,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          PayResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}