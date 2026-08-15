import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/create_reservation/i_create_reservation_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/create_reservation/i_create_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateReservationBloc
    extends Bloc<ICreateReservationEvent, ICreateReservationState> {
  CreateReservationBloc() : super(CreateReservationInitial()) {
    on<CreateReservationEvent>(_onCreateReservation);
  }

  FutureOr<void> _onCreateReservation(
    CreateReservationEvent event,
    Emitter<ICreateReservationState> emit,
  ) async {
    emit(CreateReservationLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<ReservationDataModel>?, CreateReservationEntity>>(
        instanceName: 'CreateReservationUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(CreateReservationFailed(failure.message)),
        (response) => emit(CreateReservationLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(CreateReservationFailed(e.toString()));
    }
  }
}