
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class ICancelReservationState extends Equatable {
  const ICancelReservationState();
}

final class CancelReservationInitial extends ICancelReservationState {
  @override
  List<Object> get props => [];
}

final class CancelReservationLoading extends ICancelReservationState {
  @override
  List<Object> get props => [];
}

final class CancelReservationLoaded extends ICancelReservationState {
  final BaseModel<dynamic>? resultModel;

  const CancelReservationLoaded({required this.resultModel});

  @override
  List<Object?> get props => [resultModel];
}

final class CancelReservationFailed extends ICancelReservationState {
  final String message;

  const CancelReservationFailed(this.message);

  @override
  List<Object> get props => [message];
}