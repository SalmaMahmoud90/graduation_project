

import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:equatable/equatable.dart';

class ChargeWalletCubitState extends Equatable {
  final CreateDepositRequestEntity? entity;
  const ChargeWalletCubitState({this.entity});

  ChargeWalletCubitState copyWith({CreateDepositRequestEntity? entity}) {
    return ChargeWalletCubitState(entity: entity ?? this.entity);
  }

  @override
  List<Object?> get props => [entity];
}


 