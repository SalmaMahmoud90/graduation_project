import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

import 'search_rides_state.dart';

// كيوبيت البحث عن رحلات + إنشاء حجز
class SearchRidesCubit extends Cubit<SearchRidesState> {
  SearchRidesCubit() : super(SearchRidesInitial());

  Future<void> search({
    required String location,
    required String destination,
  }) async {
    emit(SearchRidesLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RidesListModel>?, SearchRidesEntity>>(
        instanceName: 'SearchRidesUseCase',
      )(SearchRidesEntity(location: location, destination: destination));

      result.fold(
        (l) => emit(SearchRidesError(l.message)),
        (r) => emit(SearchRidesLoaded(r?.data?.rides ?? const [])),
      );
    } catch (e) {
      emit(SearchRidesError(e.toString()));
    }
  }

  // إنشاء حجز لرحلة — يعيد رسالة الخطأ عند الفشل أو null عند النجاح
  Future<String?> book({
    required int rideId,
    required String pickupLocation,
  }) async {
    try {
      final Either<AppException, BaseModel<ReservationDataModel>?> result =
          await locator<
              IUseCase<BaseModel<ReservationDataModel>?,
                  CreateReservationEntity>>(
        instanceName: 'CreateReservationUseCase',
      )(CreateReservationEntity(ride: rideId, pickupLocation: pickupLocation));

      return result.fold(
        (l) => l.message,
        (r) => r?.error, // null عند النجاح
      );
    } catch (e) {
      return e.toString();
    }
  }
}
