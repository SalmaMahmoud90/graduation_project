import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
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

  void setDate(DateTime date) {
    selectedDate = date;
    emit(PublishRideFieldsUpdatedState());
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    emit(PublishRideFieldsUpdatedState());
  }

  void setDuration(String value) {
    expectedDuration = value;
  }

  void setPrice(String value) {
    price = value;
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

  String _two(int n) => n.toString().padLeft(2, '0');

  // نشر الرحلة عبر الـ API (create ride)
  Future<void> publishRide() async {
    if (departureCity == null ||
        departureCity!.isEmpty ||
        destinationCity == null ||
        destinationCity!.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      emit(PublishRideErrorState('missing_fields'));
      return;
    }

    emit(PublishRideLoadingState());
    try {
      final date =
          '${selectedDate!.year}-${_two(selectedDate!.month)}-${_two(selectedDate!.day)}';
      final time = '${_two(selectedTime!.hour)}:${_two(selectedTime!.minute)}';
      final cost = price.replaceAll(RegExp(r'[^0-9.]'), '');

      final result = await locator<
          IUseCase<BaseModel<RideDataModel>?, CreateRideEntity>>(
        instanceName: 'CreateRideUseCase',
      )(CreateRideEntity(
        location: departureCity!,
        destination: destinationCity!,
        departureTime: time,
        departureDate: date,
        expectedDuration: expectedDuration.isEmpty ? null : expectedDuration,
        cost: cost.isEmpty ? '0' : cost,
        capacity: availableSeats,
      ));

      result.fold(
        (l) => emit(PublishRideErrorState(l.message)),
        (r) {
          final serverError = r?.error;
          if (serverError != null && serverError.isNotEmpty) {
            emit(PublishRideErrorState(serverError));
            return;
          }
          emit(PublishRideSuccessState());
        },
      );
    } catch (e) {
      emit(PublishRideErrorState(e.toString()));
    }
  }
}
