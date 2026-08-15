import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:a_tareqaak/presentation/bloc/rides/search_rides/i_search_rides_event.dart';
import 'package:a_tareqaak/presentation/bloc/rides/search_rides/i_search_rides_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchRidesBloc extends Bloc<ISearchRidesEvent, ISearchRidesState> {
  SearchRidesBloc() : super(SearchRidesInitial()) {
    on<SearchRidesEvent>(_onSearchRides);
  }

  FutureOr<void> _onSearchRides(
    SearchRidesEvent event,
    Emitter<ISearchRidesState> emit,
  ) async {
    emit(SearchRidesLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RidesListModel>?, SearchRidesEntity>>(
        instanceName: 'SearchRidesUseCase',
      )(event.entity);

      result.fold(
        (failure) => emit(SearchRidesFailed(failure.message)),
        (response) => emit(SearchRidesLoaded(response: response)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(SearchRidesFailed(e.toString()));
    }
  }
}