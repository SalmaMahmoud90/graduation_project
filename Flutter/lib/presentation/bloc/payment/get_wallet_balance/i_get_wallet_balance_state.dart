
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:equatable/equatable.dart';

sealed class IGetWalletBalanceState extends Equatable {
  const IGetWalletBalanceState();
}

final class GetWalletBalanceInitial extends IGetWalletBalanceState {
  @override
  List<Object> get props => [];
}

final class GetWalletBalanceLoading extends IGetWalletBalanceState {
  @override
  List<Object> get props => [];
}

final class GetWalletBalanceLoaded extends IGetWalletBalanceState {
  final BaseModel<WalletBalanceModel>? responseModel;

  const GetWalletBalanceLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class GetWalletBalanceFailed extends IGetWalletBalanceState {
  final String message;

  const GetWalletBalanceFailed(this.message);

  @override
  List<Object> get props => [message];
}