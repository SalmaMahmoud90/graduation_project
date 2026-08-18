
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:equatable/equatable.dart';

sealed class IPayReservationEvent extends Equatable {
  const IPayReservationEvent();
}

final class PayReservationEvent extends IPayReservationEvent {
  final PayReservationEntity entity;

  const PayReservationEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}