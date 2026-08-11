import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class DeleteRideState {}

class DeleteRideInitialState extends DeleteRideState {}

class DeleteRideLoadedState extends DeleteRideState {
  final List<RideModel> rides;

  DeleteRideLoadedState(this.rides);
}

class DeleteRideLoadingState extends DeleteRideState {}

class DeleteRideSuccessState extends DeleteRideState {
  final String deletedRideId;

  DeleteRideSuccessState(this.deletedRideId);
}

class DeleteRideErrorState extends DeleteRideState {
  final String message;

  DeleteRideErrorState(this.message);
}