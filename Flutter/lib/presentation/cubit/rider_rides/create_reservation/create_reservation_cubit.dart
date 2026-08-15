import 'package:a_tareqaak/presentation/cubit/create_reservation/create_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';

// كيوبيت نموذج حجز رحلة
class CreateReservationCubit extends Cubit<CreateReservationCubitState> {
  CreateReservationCubit()
      : super(const CreateReservationCubitState(entity: null));

  void pickupLocationChanged(int rideId, String pickupLocation) {
    emit(
      state.copyWith(
        entity: CreateReservationEntity(
          ride: rideId,
          pickupLocation: pickupLocation,
        ),
      ),
    );
  }
}