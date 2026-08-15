import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_reservation/i_cancel_reservation_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_reservation/i_cancel_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


// بلوك إلغاء حجز الراكب بـ API
class CancelReservationBloc
    extends Bloc<ICancelReservationEvent, ICancelReservationState> {
  CancelReservationBloc() : super(CancelReservationInitial()) {
    on<CancelReservationEvent>(_cancelReservation);
  }

  FutureOr<void> _cancelReservation(
    CancelReservationEvent event,
    Emitter<ICancelReservationState> emit,
  ) async {
    emit(CancelReservationLoading());
    try {
      final result = await locator<IUseCase<BaseModel<dynamic>?, IdEntity>>(
        instanceName: 'CancelReservationUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(CancelReservationFailed(l.message)),
        (r) => emit(CancelReservationLoaded(resultModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(CancelReservationFailed(e.toString()));
    }
  }
}