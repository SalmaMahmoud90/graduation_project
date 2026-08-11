import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_ride_state.dart';

// كيوبيت إدارة حذف الرحلات مع دعم السحب والزر الأحمر
class DeleteRideCubit extends Cubit<DeleteRideState> {
  DeleteRideCubit() : super(DeleteRideInitialState());

  List<RideModel> activeRides = [
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
      departureCity: 'جبلة',
      destinationCity: 'طرطوس',
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
    emit(DeleteRideLoadedState(List.from(activeRides)));
  }

  // تنفيذ عملية الحذف
  Future<void> deleteRide(String id) async {
    emit(DeleteRideLoadingState());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      activeRides.removeWhere((item) => item.id == id);
      emit(DeleteRideSuccessState(id));
      fetchRides();
    } catch (e) {
      emit(DeleteRideErrorState(e.toString()));
    }
  }
}