import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/report/get_shared_rides/i_get_shared_rides_event.dart';
import 'package:a_tareqaak/presentation/bloc/report/get_shared_rides/i_get_shared_rides_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class GetSharedRidesBloc
    extends Bloc<IGetSharedRidesEvent, IGetSharedRidesState> {
  GetSharedRidesBloc() : super(GetSharedRidesInitial()) {
    on<GetSharedRidesEvent>(_getSharedRides);
  }

  FutureOr<void> _getSharedRides(
    GetSharedRidesEvent event,
    Emitter<IGetSharedRidesState> emit,
  ) async {
    emit(GetSharedRidesLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RidesListModel>?, IdEntity>>(
        instanceName: 'GetSharedRidesUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(GetSharedRidesFailed(l.message)),
        (r) => emit(GetSharedRidesLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(GetSharedRidesFailed(e.toString()));
    }
  }
}