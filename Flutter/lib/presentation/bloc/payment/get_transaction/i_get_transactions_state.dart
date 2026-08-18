
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:equatable/equatable.dart';

sealed class IGetTransactionsState extends Equatable {
  const IGetTransactionsState();
}

final class GetTransactionsInitial extends IGetTransactionsState {
  @override
  List<Object> get props => [];
}

final class GetTransactionsLoading extends IGetTransactionsState {
  @override
  List<Object> get props => [];
}

final class GetTransactionsLoaded extends IGetTransactionsState {
  final BaseModel<TransactionsListModel>? responseModel;

  const GetTransactionsLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class GetTransactionsFailed extends IGetTransactionsState {
  final String message;

  const GetTransactionsFailed(this.message);

  @override
  List<Object> get props => [message];
}