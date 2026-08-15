import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class IRideDetailsState extends Equatable {
  const IRideDetailsState();
}

final class RideDetailsInitial extends IRideDetailsState {
  @override
  List<Object> get props => [];
}

final class RideDetailsLoading extends IRideDetailsState {
  @override
  List<Object> get props => [];
}

final class RideDetailsLoaded extends IRideDetailsState {
  final BaseModel<RideDetailsModel>? response;

  const RideDetailsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class RideDetailsFailed extends IRideDetailsState {
  final String message;

  const RideDetailsFailed(this.message);

  @override
  List<Object> get props => [message];
}