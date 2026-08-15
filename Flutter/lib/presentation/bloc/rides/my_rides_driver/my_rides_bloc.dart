import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/my_rides_driver/i_my_rides_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/my_rides_driver/i_my_rides_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRidesBloc extends Bloc<IMyRidesEvent, IMyRidesState> {
  MyRidesBloc() : super(MyRidesInitial()) {
    on<GetMyRidesEvent>(_onGetMyRides);
  }

  FutureOr<void> _onGetMyRides(
    GetMyRidesEvent event,
    Emitter<IMyRidesState> emit,
  ) async {
    emit(MyRidesLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RidesListModel>?, RidesNoParamsEntity>>(
        instanceName: 'MyRidesUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(MyRidesFailed(failure.message)),
        (response) => emit(MyRidesLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(MyRidesFailed(e.toString()));
    }
  }
}