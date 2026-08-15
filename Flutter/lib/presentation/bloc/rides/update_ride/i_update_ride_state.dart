import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class IUpdateRideState extends Equatable {
  const IUpdateRideState();
}

final class UpdateRideInitial extends IUpdateRideState {
  @override
  List<Object> get props => [];
}

final class UpdateRideLoading extends IUpdateRideState {
  @override
  List<Object> get props => [];
}

final class UpdateRideLoaded extends IUpdateRideState {
  final BaseModel<RideDataModel>? response;

  const UpdateRideLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class UpdateRideFailed extends IUpdateRideState {
  final String message;

  const UpdateRideFailed(this.message);

  @override
  List<Object> get props => [message];
}