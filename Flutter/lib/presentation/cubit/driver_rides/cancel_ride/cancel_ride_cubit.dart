import 'package:a_tareqaak/presentation/cubit/driver_rides/cancel_ride/cancel_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';


// كيوبيت نموذج وتجهيز معرف الرحلة للحذف
class CancelRideCubit extends Cubit<CancelRideCubitState> {
  CancelRideCubit() : super(const CancelRideCubitState(entity: null));

  void selectRideForCancel(int rideId) {
    emit(state.copyWith(entity: IdEntity(rideId)));
  }
}