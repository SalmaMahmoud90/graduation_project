import 'dart:async';
import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:a_tareqaak/presentation/cubit/location/ride_tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RideTrackingCubit extends Cubit<RideTrackingCubitState> {
  StreamSubscription<Position>? _gpsPositionSubscription;

  RideTrackingCubit() : super(const RideTrackingCubitState());

  void setConnected(bool connected) {
    emit(state.copyWith(isConnected: connected));
  }

  void updateDriverLocation(LocationUpdateEntity location) {
    final latLng = LatLng(location.latitude, location.longitude);
    emit(
      state.copyWith(
        driverPosition: latLng,
        lastUpdatedTime: location.recordedAt ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<void> startDriverGpsTracking({
    required Function(SendLocationEntity) onLocationTick,
  }) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    emit(state.copyWith(isTracking: true));

    _gpsPositionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);
      emit(state.copyWith(driverPosition: latLng));
      onLocationTick(
        SendLocationEntity(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    });
  }

  void stopDriverGpsTracking() {
    _gpsPositionSubscription?.cancel();
    _gpsPositionSubscription = null;
    emit(state.copyWith(isTracking: false));
  }

  @override
  Future<void> close() {
    stopDriverGpsTracking();
    return super.close();
  }
}