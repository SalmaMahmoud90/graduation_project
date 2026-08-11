import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'publish_ride_state.dart';

// كيوبيت إدارة إنشاء ونشر رحلة جديدة
class PublishRideCubit extends Cubit<PublishRideState> {
  PublishRideCubit() : super(PublishRideInitialState());

  String? departureCity;
  String? destinationCity;
  DateTime? selectedDate = DateTime(2026, 8, 15);
  TimeOfDay? selectedTime = const TimeOfDay(hour: 8, minute: 30);
  String expectedDuration = '3 ساعات';
  String price = '50,000';
  int availableSeats = 3;

  void setDepartureCity(String city) {
    departureCity = city;
    emit(PublishRideFieldsUpdatedState());
  }

  void setDestinationCity(String city) {
    destinationCity = city;
    emit(PublishRideFieldsUpdatedState());
  }

  void incrementSeats() {
    availableSeats++;
    emit(PublishRideFieldsUpdatedState());
  }

  void decrementSeats() {
    if (availableSeats > 1) {
      availableSeats--;
      emit(PublishRideFieldsUpdatedState());
    }
  }

  // نشر الرحلة بعد التحقق
  Future<void> publishRide() async {
    emit(PublishRideLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(PublishRideSuccessState());
    } catch (e) {
      emit(PublishRideErrorState(e.toString()));
    }
  }
}