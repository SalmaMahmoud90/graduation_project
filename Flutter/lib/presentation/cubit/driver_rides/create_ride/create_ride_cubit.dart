import 'package:a_tareqaak/presentation/cubit/driver_rides/create_ride/create_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';

// كيوبيت نموذج إدخال إنشاء رحلة جديدة
class CreateRideCubit extends Cubit<CreateRideCubitState> {
  CreateRideCubit() : super(const CreateRideCubitState(entity: null));

  void locationChanged(String location) {
    _updateEntity(location: location);
  }

  void destinationChanged(String destination) {
    _updateEntity(destination: destination);
  }

  void departureDateChanged(String date) {
    _updateEntity(departureDate: date);
  }

  void departureTimeChanged(String time) {
    _updateEntity(departureTime: time);
  }

  void expectedDurationChanged(String duration) {
    _updateEntity(expectedDuration: duration);
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
    String? departureDate,
    String? departureTime,
    String? expectedDuration,
    String? cost,
    int? capacity,
  }) {
    final current = state.entity ??
        const CreateRideEntity(
          location: '',
          destination: '',
          departureTime: '08:30:00',
          departureDate: '2026-08-15',
          cost: '50000',
          capacity: 3,
        );

    emit(
      state.copyWith(
        entity: CreateRideEntity(
          location: location ?? current.location,
          destination: destination ?? current.destination,
          departureTime: departureTime ?? current.departureTime,
          departureDate: departureDate ?? current.departureDate,
          expectedDuration: expectedDuration ?? current.expectedDuration,
          cost: cost ?? current.cost,
          capacity: capacity ?? current.capacity,
        ),
      ),
    );
  }
}