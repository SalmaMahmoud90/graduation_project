
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';

abstract class RideReservationsState {}

class RideReservationsInitial extends RideReservationsState {}

class RideReservationsLoaded extends RideReservationsState {
  final List<ReservationDataModel> reservations;

  RideReservationsLoaded(this.reservations);
}