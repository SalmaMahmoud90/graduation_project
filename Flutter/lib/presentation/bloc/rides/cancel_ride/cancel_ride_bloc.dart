import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_ride/i_cancel_ride_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/cancel_ride/i_cancel_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelRideBloc extends Bloc<ICancelRideEvent, ICancelRideState> {
  CancelRideBloc() : super(CancelRideInitial()) {
    on<CancelRideEvent>(_onCancelRide);
  }

  FutureOr<void> _onCancelRide(
    CancelRideEvent event,
    Emitter<ICancelRideState> emit,
  ) async {
    emit(CancelRideLoading());
    try {
      final result = await locator<IUseCase<BaseModel<dynamic>?, IdEntity>>(
        instanceName: 'CancelRideUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(CancelRideFailed(failure.message)),
        (response) => emit(CancelRideLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(CancelRideFailed(e.toString()));
    }
  }
}