
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:equatable/equatable.dart';

class PayReservationCubitState extends Equatable {
  final PayReservationEntity? entity;

  const PayReservationCubitState({required this.entity});

  PayReservationCubitState copyWith({PayReservationEntity? entity}) {
    return PayReservationCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}