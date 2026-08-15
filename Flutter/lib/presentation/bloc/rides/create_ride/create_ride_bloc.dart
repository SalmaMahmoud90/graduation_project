import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/create_ride/i_create_ride_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/create_ride/i_create_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRideBloc extends Bloc<ICreateRideEvent, ICreateRideState> {
  CreateRideBloc() : super(CreateRideInitial()) {
    on<CreateRideEvent>(_onCreateRide);
  }

  FutureOr<void> _onCreateRide(
    CreateRideEvent event,
    Emitter<ICreateRideState> emit,
  ) async {
    emit(CreateRideLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RideDataModel>?, CreateRideEntity>>(
        instanceName: 'CreateRideUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(CreateRideFailed(failure.message)),
        (response) => emit(CreateRideLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(CreateRideFailed(e.toString()));
    }
  }
}