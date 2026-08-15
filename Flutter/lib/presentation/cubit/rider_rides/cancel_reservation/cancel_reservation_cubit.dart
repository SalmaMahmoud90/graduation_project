import 'package:a_tareqaak/presentation/cubit/rider_rides/cancel_reservation/cancel_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';


// كيوبيت نموذج وتجهيز معرف الحجز للإلغاء
class CancelReservationCubit extends Cubit<CancelReservationCubitState> {
  CancelReservationCubit()
      : super(const CancelReservationCubitState(entity: null));

  void selectReservationForCancel(int reservationId) {
    emit(state.copyWith(entity: IdEntity(reservationId)));
  }
}