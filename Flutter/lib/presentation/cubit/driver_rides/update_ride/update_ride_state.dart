
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:equatable/equatable.dart';

class UpdateRideCubitState extends Equatable {
  final UpdateRideEntity? entity;

  const UpdateRideCubitState({required this.entity});

  UpdateRideCubitState copyWith({
    UpdateRideEntity? entity,
  }) {
    return UpdateRideCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}