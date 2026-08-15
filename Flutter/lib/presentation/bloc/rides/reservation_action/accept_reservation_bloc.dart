import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/reservation_action/i_accept_reservation_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/reservation_action/i_accept_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationActionBloc
    extends Bloc<IReservationActionEvent, IReservationActionState> {
  ReservationActionBloc() : super(ReservationActionInitial()) {
    on<AcceptReservationEvent>(_onAccept);
    on<RejectReservationEvent>(_onReject);
  }

  FutureOr<void> _onAccept(
    AcceptReservationEvent event,
    Emitter<IReservationActionState> emit,
  ) async {
    emit(ReservationActionLoading());
    try {
      final result = await locator<IUseCase<BaseModel<dynamic>?, IdEntity>>(
        instanceName: 'AcceptReservationUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(ReservationActionFailed(failure.message)),
        (response) => emit(ReservationActionSuccess(
          response: response,
          message: 'تم قبول الحجز بنجاح',
        )),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(ReservationActionFailed(e.toString()));
    }
  }

  FutureOr<void> _onReject(
    RejectReservationEvent event,
    Emitter<IReservationActionState> emit,
  ) async {
    emit(ReservationActionLoading());
    try {
      final result = await locator<IUseCase<BaseModel<dynamic>?, IdEntity>>(
        instanceName: 'RejectReservationUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(ReservationActionFailed(failure.message)),
        (response) => emit(ReservationActionSuccess(
          response: response,
          message: 'تم رفض الحجز',
        )),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(ReservationActionFailed(e.toString()));
    }
  }
}