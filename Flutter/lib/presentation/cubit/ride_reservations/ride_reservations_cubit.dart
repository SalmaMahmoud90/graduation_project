import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'ride_reservations_state.dart';


// كيوبيت إدارة قائمة طلبات الحجز المعلقة بالسائق
class RideReservationsCubit extends Cubit<RideReservationsState> {
  RideReservationsCubit() : super(RideReservationsInitial());

  List<ReservationDataModel> pendingReservations = [
    const ReservationDataModel(
      id: 101,
      ride: 1,
      rider: 5,
      riderName: 'سامر الحمصي',
      rideLocation: 'اللاذقية',
      rideDestination: 'دمشق',
      pickupLocation: 'موقف البولمان - اللاذقية',
      status: 'pending',
    ),
    const ReservationDataModel(
      id: 102,
      ride: 1,
      rider: 8,
      riderName: 'محمد خالد',
      rideLocation: 'اللاذقية',
      rideDestination: 'دمشق',
      pickupLocation: 'دوار الأزهري',
      status: 'pending',
    ),
  ];

  void fetchPendingReservations() {
    emit(RideReservationsLoaded(List.from(pendingReservations)));
  }

  void removeReservationLocally(int reservationId) {
    pendingReservations.removeWhere((item) => item.id == reservationId);
    emit(RideReservationsLoaded(List.from(pendingReservations)));
  }
}