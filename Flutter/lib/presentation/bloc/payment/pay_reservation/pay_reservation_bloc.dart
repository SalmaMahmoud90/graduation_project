import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/presentation/bloc/payment/pay_reservation/i_pay_reservation_event.dart';
import 'package:a_tareqaak/presentation/bloc/payment/pay_reservation/i_pay_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class PayReservationBloc
    extends Bloc<IPayReservationEvent, IPayReservationState> {
  PayReservationBloc() : super(PayReservationInitial()) {
    on<PayReservationEvent>(_payReservation);
  }

  FutureOr<void> _payReservation(
    PayReservationEvent event,
    Emitter<IPayReservationState> emit,
  ) async {
    emit(PayReservationLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<PayResponseModel>?, PayReservationEntity>>(
        instanceName: 'PayReservationUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(PayReservationFailed(l.message)),
        (r) => emit(PayReservationLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PayReservationFailed(e.toString()));
    }
  }
}