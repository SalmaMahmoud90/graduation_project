import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_ride_state.dart';

class EditRideCubit extends Cubit<EditRideState> {
  final RideModel? initialRide;

  EditRideCubit({this.initialRide}) : super(EditRideInitialState()) {
    if (initialRide != null) {
      departureCity = initialRide!.departureCity;
      destinationCity = initialRide!.destinationCity;
      departureDateTime = initialRide!.departureDateTime;
      expectedDuration = initialRide!.duration;
      price = initialRide!.price.toInt().toString();
      availableSeats = initialRide!.availableSeats;
    }
  }

  String departureCity = 'اللاذقية';
  String destinationCity = 'دمشق';
  DateTime departureDateTime = DateTime(2026, 8, 15, 8, 30);
  String expectedDuration = '3 ساعات';
  String price = '50000';
  int availableSeats = 4;

  bool get isEditable {
    final difference = departureDateTime.difference(DateTime.now());
    return difference.inHours >= 6;
  }

  void incrementSeats() {
    if (!isEditable) return;
    availableSeats++;
    emit(EditRideSeatsChangedState(availableSeats));
  }

  void decrementSeats() {
    if (!isEditable || availableSeats <= 1) return;
    availableSeats--;
    emit(EditRideSeatsChangedState(availableSeats));
  }

  // حفظ التعديلات وإرجاع كائن الرحلة المحدث بنجاح
  Future<void> saveChanges() async {
    if (!isEditable) return;

    emit(EditRideLoadingState());
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final updatedRide = RideModel(
        id: initialRide?.id ?? '1',
        departureCity: departureCity,
        destinationCity: destinationCity,
        departureDateTime: departureDateTime,
        duration: expectedDuration,
        price: double.tryParse(price) ?? 50000,
        availableSeats: availableSeats,
      );
      emit(EditRideSuccessState(updatedRide));
    } catch (e) {
      emit(EditRideErrorState(e.toString()));
    }
  }
}