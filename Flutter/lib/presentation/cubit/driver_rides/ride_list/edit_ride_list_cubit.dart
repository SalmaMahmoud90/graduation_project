import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/presentation/cubit/driver_rides/ride_list/edit_ride_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRideListCubit extends Cubit<EditRideListState> {
  EditRideListCubit() : super(EditRideListInitialState());

  List<RideModel> rides = [
    RideModel(
      id: '1',
      departureCity: 'اللاذقية',
      destinationCity: 'دمشق',
      departureDateTime: DateTime(2026, 8, 15, 8, 30),
      duration: '3 ساعات',
      price: 50000,
      availableSeats: 4,
    ),
    RideModel(
      id: '2',
      departureCity: 'طرطوس',
      destinationCity: 'جبلة',
      departureDateTime: DateTime(2026, 8, 16, 9, 0),
      duration: '1 ساعة',
      price: 30000,
      availableSeats: 3,
    ),
    RideModel(
      id: '3',
      departureCity: 'اللاذقية',
      destinationCity: 'حلب',
      departureDateTime: DateTime(2026, 8, 17, 7, 0),
      duration: '2.5 ساعة',
      price: 50000,
      availableSeats: 2,
    ),
    RideModel(
      id: '4',
      departureCity: 'طرطوس',
      destinationCity: 'دمشق',
      departureDateTime: DateTime(2026, 8, 18, 10, 30),
      duration: '3 ساعات',
      price: 40000,
      availableSeats: 3,
    ),
  ];

  void fetchRides() {
    emit(EditRideListLoadedState(List.from(rides)));
  }

  // تحديث الرحلة المعدلة داخل القائمة فورياً عند حفظ التعديلات
  void updateRide(RideModel updatedRide) {
    final index = rides.indexWhere((r) => r.id == updatedRide.id);
    if (index != -1) {
      rides[index] = updatedRide;
      emit(EditRideListLoadedState(List.from(rides)));
    }
  }
}