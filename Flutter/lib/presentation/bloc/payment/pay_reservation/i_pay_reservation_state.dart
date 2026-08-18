
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:equatable/equatable.dart';

sealed class IPayReservationState extends Equatable {
  const IPayReservationState();
}

final class PayReservationInitial extends IPayReservationState {
  @override
  List<Object> get props => [];
}

final class PayReservationLoading extends IPayReservationState {
  @override
  List<Object> get props => [];
}

final class PayReservationLoaded extends IPayReservationState {
  final BaseModel<PayResponseModel>? responseModel;

  const PayReservationLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class PayReservationFailed extends IPayReservationState {
  final String message;

  const PayReservationFailed(this.message);

  @override
  List<Object> get props => [message];
}