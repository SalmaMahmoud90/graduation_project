import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class MyRidesState extends Equatable {
  const MyRidesState();
  @override
  List<Object?> get props => [];
}

class MyRidesInitial extends MyRidesState {}

class MyRidesLoading extends MyRidesState {}

class MyRidesLoaded extends MyRidesState {
  final List<RideDataModel> rides;
  const MyRidesLoaded(this.rides);
  @override
  List<Object?> get props => [rides];
}

class MyRidesError extends MyRidesState {
  final String message;
  const MyRidesError(this.message);
  @override
  List<Object?> get props => [message];
}
