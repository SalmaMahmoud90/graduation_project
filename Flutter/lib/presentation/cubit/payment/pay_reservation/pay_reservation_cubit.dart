import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/presentation/cubit/payment/pay_reservation/pay_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PayReservationCubit extends Cubit<PayReservationCubitState> {
  PayReservationCubit() : super(const PayReservationCubitState(entity: null));

  void selectReservation(int reservationId) {
    emit(state.copyWith(entity: PayReservationEntity(reservationId)));
  }
}