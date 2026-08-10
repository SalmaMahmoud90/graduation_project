import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';

class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);

    return SizedBox(
      height: AppHeight.h325,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r25),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 16,
          ),

          // Marker على موقع الجهاز
          markers: {
            Marker(
              markerId: const MarkerId('current_device_location'),
              position: position,
            ),
          },

          // موقع المستخدم داخل Google Maps
          myLocationEnabled: true,
          myLocationButtonEnabled: true,

          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          buildingsEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: false,
          fortyFiveDegreeImageryEnabled: false,

          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,

          gestureRecognizers: {
            Factory<EagerGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
      ),
    );
  }
}