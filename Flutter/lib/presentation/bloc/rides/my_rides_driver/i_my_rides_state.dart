import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class IMyRidesState extends Equatable {
  const IMyRidesState();
}

final class MyRidesInitial extends IMyRidesState {
  @override
  List<Object> get props => [];
}

final class MyRidesLoading extends IMyRidesState {
  @override
  List<Object> get props => [];
}

final class MyRidesLoaded extends IMyRidesState {
  final BaseModel<RidesListModel>? response;

  const MyRidesLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class MyRidesFailed extends IMyRidesState {
  final String message;

  const MyRidesFailed(this.message);

  @override
  List<Object> get props => [message];
}