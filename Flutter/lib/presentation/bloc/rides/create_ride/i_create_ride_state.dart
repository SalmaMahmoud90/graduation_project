import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateRideState extends Equatable {
  const ICreateRideState();
}

final class CreateRideInitial extends ICreateRideState {
  @override
  List<Object> get props => [];
}

final class CreateRideLoading extends ICreateRideState {
  @override
  List<Object> get props => [];
}

final class CreateRideLoaded extends ICreateRideState {
  final BaseModel<RideDataModel>? response;

  const CreateRideLoaded({required this.response, BaseModel<RideDataModel>? rideModel});

  @override
  List<Object?> get props => [response];
}

final class CreateRideFailed extends ICreateRideState {
  final String message;

  const CreateRideFailed(this.message);

  @override
  List<Object> get props => [message];
}