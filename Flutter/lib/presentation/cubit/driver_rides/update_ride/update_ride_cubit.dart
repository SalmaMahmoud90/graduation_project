
import 'package:a_tareqaak/presentation/cubit/driver_rides/update_ride/update_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';


// كيوبيت نموذج وتعديل حقول الرحلة
class UpdateRideCubit extends Cubit<UpdateRideCubitState> {
  final RideModel? initialRide;

  UpdateRideCubit({this.initialRide})
      : super(UpdateRideCubitState(
          entity: initialRide != null
              ? UpdateRideEntity(
                  id: int.parse(initialRide.id),
                  location: initialRide.departureCity,
                  destination: initialRide.destinationCity,
                  cost: initialRide.price.toInt().toString(),
                  capacity: initialRide.availableSeats,
                )
              : null,
        ));

  void locationChanged(String location) {
    _updateEntity(location: location);
  }

  void destinationChanged(String destination) {
    _updateEntity(destination: destination);
  }

  void costChanged(String cost) {
    _updateEntity(cost: cost);
  }

  void capacityChanged(int capacity) {
    _updateEntity(capacity: capacity);
  }

  void _updateEntity({
    String? location,
    String? destination,
    String? cost,
    int? capacity,
  }) {
    final current = state.entity ?? UpdateRideEntity(id: int.parse(initialRide?.id ?? '1'));
    emit(
      state.copyWith(
        entity: UpdateRideEntity(
          id: current.id,
          location: location ?? current.location,
          destination: destination ?? current.destination,
          cost: cost ?? current.cost,
          capacity: capacity ?? current.capacity,
        ),
      ),
    );
  }
}