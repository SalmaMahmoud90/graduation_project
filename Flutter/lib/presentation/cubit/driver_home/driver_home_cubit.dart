import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'driver_home_state.dart';

class DriverHomeCubit extends Cubit<DriverHomeState> {
  DriverHomeCubit() : super(DriverHomeInitialState());

  double? currentLat;
  double? currentLng;
  String? currentLocationName;

  int currentTabIndex = 0;

  /// تغيير التاب
  void changeTab(int index) {
    currentTabIndex = index;
    emit(DriverHomeInitialState());
  }

  /// جلب الموقع الحقيقي للجهاز
Future<void> requestLocationAndFetch({
  required Locale locale,
  VoidCallback? onGranted,
  VoidCallback? onDenied,
}) async {
  emit(DriverHomeLocationLoadingState());

  try {
    // 1. التأكد من أن خدمة الموقع مفعلة
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // فتح إعدادات الموقع
      await Geolocator.openLocationSettings();

      // بعد عودة المستخدم للتطبيق
      serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        onDenied?.call();
        emit(DriverHomeInitialState());
        return;
      }
    }

    // 2. فحص صلاحية الموقع
    LocationPermission permission =
        await Geolocator.checkPermission();

    // 3. طلب الصلاحية إذا لم تكن ممنوحة
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 4. إذا بقيت مرفوضة
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      onDenied?.call();
      emit(DriverHomeInitialState());
      return;
    }

    // 5. الحصول على الموقع
    final Position position =
        await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    // 6. تخزين الإحداثيات
    currentLat = position.latitude;
    currentLng = position.longitude;

    // 7. تحويل الإحداثيات إلى اسم مكان
    final String locationName =
        await _getLocationName(
      latitude: position.latitude,
      longitude: position.longitude,
      locale: locale,
    );

    // 8. تخزين اسم الموقع
    currentLocationName = locationName;

    // 9. تحديث الواجهة
    emit(
      DriverHomeLocationUpdatedState(
        lat: position.latitude,
        lng: position.longitude,
        locationName: locationName,
      ),
    );

    // 10. نجاح
    onGranted?.call();
  } catch (e) {
    debugPrint('Location error: $e');

    onDenied?.call();

    emit(DriverHomeInitialState());
  }
}
  /// تحويل GPS coordinates إلى اسم المكان
  Future<String> _getLocationName({
    required double latitude,
    required double longitude,
    required Locale locale,
  }) async {
    try {
      final Geocoding geocoding = Geocoding();

      final List<Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
        locale: locale,
      );

      if (placemarks.isEmpty) {
        return '';
      }

      final Placemark place = placemarks.first;

      final List<String> parts = [];

      // المدينة
      if (place.locality?.trim().isNotEmpty == true) {
        parts.add(
          place.locality!.trim(),
        );
      }

      // المنطقة / الحي
      if (place.subLocality?.trim().isNotEmpty == true) {
        parts.add(
          place.subLocality!.trim(),
        );
      }

      // الشارع
      if (place.street?.trim().isNotEmpty == true) {
        parts.add(
          place.street!.trim(),
        );
      }

      return parts.join(' - ');
    } catch (e) {
      debugPrint(
        'Geocoding error: $e',
      );

      return '';
    }
  }
}