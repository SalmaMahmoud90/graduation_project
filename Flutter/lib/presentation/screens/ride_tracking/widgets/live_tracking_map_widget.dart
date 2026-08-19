import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingMapWidget extends StatefulWidget {
  final LatLng? driverPosition;
  final double zoom;

  const LiveTrackingMapWidget({
    super.key,
    this.driverPosition,
    this.zoom = 16.0,
  });

  @override
  State<LiveTrackingMapWidget> createState() => _LiveTrackingMapWidgetState();
}

class _LiveTrackingMapWidgetState extends State<LiveTrackingMapWidget> {
  GoogleMapController? _mapController;

  @override
  void didUpdateWidget(covariant LiveTrackingMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.driverPosition != null &&
        widget.driverPosition != oldWidget.driverPosition) {
      _animateToPosition(widget.driverPosition!);
    }
  }

  void _animateToPosition(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: widget.zoom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الموقع الافتراضي في حال لم يصل بعد
    final initialTarget = widget.driverPosition ?? const LatLng(33.5138, 36.2765);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialTarget,
        zoom: widget.zoom,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        if (widget.driverPosition != null) {
          _animateToPosition(widget.driverPosition!);
        }
      },
      markers: {
        if (widget.driverPosition != null)
          Marker(
            markerId: const MarkerId('driver_live_location'),
            position: widget.driverPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: const InfoWindow(title: 'موقع السائق المباشر'),
          ),
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
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
    );
  }
}