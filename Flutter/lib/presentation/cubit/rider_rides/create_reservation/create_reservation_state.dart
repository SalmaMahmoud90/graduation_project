
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:equatable/equatable.dart';

class CreateReservationCubitState extends Equatable {
  final CreateReservationEntity? entity;

  const CreateReservationCubitState({required this.entity});

  CreateReservationCubitState copyWith({
    CreateReservationEntity? entity,
  }) {
    return CreateReservationCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}