import 'package:equatable/equatable.dart';

// كيان طلب إيداع رصيد
class CreateDepositRequestEntity extends Equatable {
  final String amount;
  final String paymentMethod;
  final String transactionReference;

  const CreateDepositRequestEntity({
    required this.amount,
    required this.paymentMethod,
    required this.transactionReference,
  });

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "payment_method": paymentMethod,
        "transaction_reference": transactionReference,
      };

  @override
  List<Object?> get props => [amount, paymentMethod, transactionReference];
}

// كيان دفع قيمة حجز
class PayReservationEntity extends Equatable {
  final int reservationId;

  const PayReservationEntity(this.reservationId);

  Map<String, dynamic> toJson() => {
        "reservation": reservationId,
      };

  @override
  List<Object?> get props => [reservationId];
}