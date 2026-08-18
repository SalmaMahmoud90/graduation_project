

import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:equatable/equatable.dart';

sealed class IGetDepositRequestsState extends Equatable {
  const IGetDepositRequestsState();
}

final class GetDepositRequestsInitial extends IGetDepositRequestsState {
  @override
  List<Object> get props => [];
}

final class GetDepositRequestsLoading extends IGetDepositRequestsState {
  @override
  List<Object> get props => [];
}

final class GetDepositRequestsLoaded extends IGetDepositRequestsState {
  final BaseModel<DepositRequestsListModel>? responseModel;

  const GetDepositRequestsLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class GetDepositRequestsFailed extends IGetDepositRequestsState {
  final String message;

  const GetDepositRequestsFailed(this.message);

  @override
  List<Object> get props => [message];
}