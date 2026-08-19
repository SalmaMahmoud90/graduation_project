import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideTrackingCubitState extends Equatable {
  final LatLng? driverPosition;
  final bool isTracking;
  final bool isConnected;
  final String? lastUpdatedTime;
  final double currentZoom;

  const RideTrackingCubitState({
    this.driverPosition,
    this.isTracking = false,
    this.isConnected = false,
    this.lastUpdatedTime,
    this.currentZoom = 16.0,
  });

  RideTrackingCubitState copyWith({
    LatLng? driverPosition,
    bool? isTracking,
    bool? isConnected,
    String? lastUpdatedTime,
    double? currentZoom,
  }) {
    return RideTrackingCubitState(
      driverPosition: driverPosition ?? this.driverPosition,
      isTracking: isTracking ?? this.isTracking,
      isConnected: isConnected ?? this.isConnected,
      lastUpdatedTime: lastUpdatedTime ?? this.lastUpdatedTime,
      currentZoom: currentZoom ?? this.currentZoom,
    );
  }

  @override
  List<Object?> get props => [
        driverPosition,
        isTracking,
        isConnected,
        lastUpdatedTime,
        currentZoom,
      ];
}