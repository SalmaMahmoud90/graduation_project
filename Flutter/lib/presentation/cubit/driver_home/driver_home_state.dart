abstract class DriverHomeState {}

class DriverHomeInitialState extends DriverHomeState {}

class DriverHomeLocationLoadingState extends DriverHomeState {}

class DriverHomeLocationUpdatedState extends DriverHomeState {
  final double lat;
  final double lng;
  final String locationName;

  DriverHomeLocationUpdatedState({
    required this.lat,
    required this.lng,
    required this.locationName,
  });
}