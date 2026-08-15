import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/i_ride_details_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/ride_details/i_ride_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideDetailsBloc extends Bloc<IRideDetailsEvent, IRideDetailsState> {
  RideDetailsBloc() : super(RideDetailsInitial()) {
    on<GetRideDetailsEvent>(_onGetRideDetails);
  }

  FutureOr<void> _onGetRideDetails(
    GetRideDetailsEvent event,
    Emitter<IRideDetailsState> emit,
  ) async {
    emit(RideDetailsLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RideDetailsModel>?, IdEntity>>(
        instanceName: 'RideDetailsUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(RideDetailsFailed(failure.message)),
        (response) => emit(RideDetailsLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(RideDetailsFailed(e.toString()));
    }
  }
}