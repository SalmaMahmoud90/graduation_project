

import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateDepositRequestState extends Equatable {
  const ICreateDepositRequestState();
}

final class CreateDepositRequestInitial extends ICreateDepositRequestState {
  @override
  List<Object> get props => [];
}

final class CreateDepositRequestLoading extends ICreateDepositRequestState {
  @override
  List<Object> get props => [];
}

final class CreateDepositRequestLoaded extends ICreateDepositRequestState {
  final BaseModel<DepositRequestDataModel>? responseModel;
  const CreateDepositRequestLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class CreateDepositRequestFailed extends ICreateDepositRequestState {
  final String message;
  const CreateDepositRequestFailed(this.message);

  @override
  List<Object> get props => [message];
}