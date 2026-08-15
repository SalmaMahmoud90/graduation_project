import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/update_ride/i_update_ride_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/update_ride/i_update_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateRideBloc extends Bloc<IUpdateRideEvent, IUpdateRideState> {
  UpdateRideBloc() : super(UpdateRideInitial()) {
    on<UpdateRideEvent>(_onUpdateRide);
  }

  FutureOr<void> _onUpdateRide(
    UpdateRideEvent event,
    Emitter<IUpdateRideState> emit,
  ) async {
    emit(UpdateRideLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RideDataModel>?, UpdateRideEntity>>(
        instanceName: 'UpdateRideUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(UpdateRideFailed(failure.message)),
        (response) => emit(UpdateRideLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(UpdateRideFailed(e.toString()));
    }
  }
}