// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletBalanceModel _$WalletBalanceModelFromJson(Map<String, dynamic> json) =>
    WalletBalanceModel(balance: json['balance'] as String?);

DepositRequestDataModel _$DepositRequestDataModelFromJson(
  Map<String, dynamic> json,
) => DepositRequestDataModel(
  id: (json['id'] as num?)?.toInt(),
  amount: json['amount'] as String?,
  paymentMethod: json['payment_method'] as String?,
  transactionReference: json['transaction_reference'] as String?,
  status: json['status'] as String?,
  createdAt: json['created_at'] as String?,
);

DepositRequestsListModel _$DepositRequestsListModelFromJson(
  Map<String, dynamic> json,
) => DepositRequestsListModel(
  depositRequests: (json['deposit_requests'] as List<dynamic>?)
      ?.map((e) => DepositRequestDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

TransactionDataModel _$TransactionDataModelFromJson(
  Map<String, dynamic> json,
) => TransactionDataModel(
  id: (json['id'] as num?)?.toInt(),
  transactionType: json['transaction_type'] as String?,
  createdAt: json['created_at'] as String?,
);

TransactionsListModel _$TransactionsListModelFromJson(
  Map<String, dynamic> json,
) => TransactionsListModel(
  transactions: (json['transactions'] as List<dynamic>?)
      ?.map((e) => TransactionDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

PayResponseModel _$PayResponseModelFromJson(Map<String, dynamic> json) =>
    PayResponseModel(
      message: json['message'] as String?,
      transactionId: (json['transaction_id'] as num?)?.toInt(),
      remainingBalance: json['remaining_balance'] as String?,
    );
