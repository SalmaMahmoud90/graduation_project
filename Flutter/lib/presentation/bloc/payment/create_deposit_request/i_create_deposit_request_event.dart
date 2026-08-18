
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ICreateDepositRequestEvent extends Equatable {
  const ICreateDepositRequestEvent();
}

final class CreateDepositRequestEvent extends ICreateDepositRequestEvent {
  final CreateDepositRequestEntity entity;
  const CreateDepositRequestEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}