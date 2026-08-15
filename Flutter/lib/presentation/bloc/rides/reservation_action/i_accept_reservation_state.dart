import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class IReservationActionState extends Equatable {
  const IReservationActionState();
}

final class ReservationActionInitial extends IReservationActionState {
  @override
  List<Object> get props => [];
}

final class ReservationActionLoading extends IReservationActionState {
  @override
  List<Object> get props => [];
}

final class ReservationActionSuccess extends IReservationActionState {
  final BaseModel<dynamic>? response;
  final String message;

  const ReservationActionSuccess({required this.response, required this.message});

  @override
  List<Object?> get props => [response, message];
}

final class ReservationActionFailed extends IReservationActionState {
  final String message;

  const ReservationActionFailed(this.message);

  @override
  List<Object> get props => [message];
}