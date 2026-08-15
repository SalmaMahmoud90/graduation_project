import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateReservationState extends Equatable {
  const ICreateReservationState();
}

final class CreateReservationInitial extends ICreateReservationState {
  @override
  List<Object> get props => [];
}

final class CreateReservationLoading extends ICreateReservationState {
  @override
  List<Object> get props => [];
}

final class CreateReservationLoaded extends ICreateReservationState {
  final BaseModel<ReservationDataModel>? response;

  const CreateReservationLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class CreateReservationFailed extends ICreateReservationState {
  final String message;

  const CreateReservationFailed(this.message);

  @override
  List<Object> get props => [message];
}