import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter/foundation.dart';

// الكلاس المجرد الأساسي لحالات تعديل الرحلة
@immutable
abstract class EditRideState {}

// الحالة الأولية للشاشة
class EditRideInitialState extends EditRideState {}

// حالة تغيير بيانات الحقول
class EditRideFieldsChangedState extends EditRideState {}

// حالة تغيير عدد المقاعد المتاحة
class EditRideSeatsChangedState extends EditRideState {
  final int seats;

  EditRideSeatsChangedState(this.seats);
}

// حالة التحميل أثناء حفظ التعديلات
class EditRideLoadingState extends EditRideState {}

// حالة نجاح حفظ التعديلات وحمل كائن الرحلة المحدث (حل المشكلة الأولى والثانية)
class EditRideSuccessState extends EditRideState {
  final RideModel updatedRide;

  EditRideSuccessState(this.updatedRide);
}

// حالة الخطأ في التعديل
class EditRideErrorState extends EditRideState {
  final String message;

  EditRideErrorState(this.message);
}