
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:equatable/equatable.dart';

class CreateRideCubitState extends Equatable {
  final CreateRideEntity? entity;

  const CreateRideCubitState({required this.entity});

  CreateRideCubitState copyWith({
    CreateRideEntity? entity,
  }) {
    return CreateRideCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}