import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RideDetailsState {}

class RideDetailsInitialState extends RideDetailsState {}

class RideDetailsLoadedState extends RideDetailsState {
  final RideModel ride;

  RideDetailsLoadedState(this.ride);
}

class RideDetailsLoadingState extends RideDetailsState {}

class RideDetailsErrorState extends RideDetailsState {
  final String message;

  RideDetailsErrorState(this.message);
}