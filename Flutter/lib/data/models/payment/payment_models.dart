import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_models.g.dart';

// 1. نموذج رصيد المحفظة
@JsonSerializable(createToJson: false)
class WalletBalanceModel extends Equatable {
  final String? balance;

  const WalletBalanceModel({this.balance});

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceModelFromJson(json);

  @override
  List<Object?> get props => [balance];
}

// 2. نموذج طلب الإيداع
@JsonSerializable(createToJson: false)
class DepositRequestDataModel extends Equatable {
  final int? id;
  final String? amount;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @JsonKey(name: 'transaction_reference')
  final String? transactionReference;
  final String? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const DepositRequestDataModel({
    this.id,
    this.amount,
    this.paymentMethod,
    this.transactionReference,
    this.status,
    this.createdAt,
  });

  factory DepositRequestDataModel.fromJson(Map<String, dynamic> json) =>
      _$DepositRequestDataModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        amount,
        paymentMethod,
        transactionReference,
        status,
        createdAt,
      ];
}

// غلاف قائمة طلبات الإيداع
@JsonSerializable(createToJson: false)
class DepositRequestsListModel extends Equatable {
  @JsonKey(name: 'deposit_requests')
  final List<DepositRequestDataModel>? depositRequests;

  const DepositRequestsListModel({this.depositRequests});

  factory DepositRequestsListModel.fromJson(Map<String, dynamic> json) =>
      _$DepositRequestsListModelFromJson(json);

  @override
  List<Object?> get props => [depositRequests];
}

// 3. نموذج المعاملة المالية
@JsonSerializable(createToJson: false)
class TransactionDataModel extends Equatable {
  final int? id;
  @JsonKey(name: 'transaction_type')
  final String? transactionType;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const TransactionDataModel({
    this.id,
    this.transactionType,
    this.createdAt,
  });

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataModelFromJson(json);

  @override
  List<Object?> get props => [id, transactionType, createdAt];
}

// غلاف سجل المعاملات
@JsonSerializable(createToJson: false)
class TransactionsListModel extends Equatable {
  final List<TransactionDataModel>? transactions;

  const TransactionsListModel({this.transactions});

  factory TransactionsListModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionsListModelFromJson(json);

  @override
  List<Object?> get props => [transactions];
}

// 4. نموذج استجابة الدفع
@JsonSerializable(createToJson: false)
class PayResponseModel extends Equatable {
  final String? message;
  @JsonKey(name: 'transaction_id')
  final int? transactionId;
  @JsonKey(name: 'remaining_balance')
  final String? remainingBalance;

  const PayResponseModel({
    this.message,
    this.transactionId,
    this.remainingBalance,
  });

  factory PayResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PayResponseModelFromJson(json);

  @override
  List<Object?> get props => [message, transactionId, remainingBalance];
}