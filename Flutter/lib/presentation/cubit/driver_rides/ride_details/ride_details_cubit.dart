import 'package:a_tareqaak/data/models/ride/ride_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ride_details_state.dart';

// كيوبيت إدارة تفاصيل الرحلة
class RideDetailsCubit extends Cubit<RideDetailsState> {
  RideDetailsCubit() : super(RideDetailsInitialState());

  void loadRideDetails(RideModel ride) {
    emit(RideDetailsLoadingState());
    try {
      emit(RideDetailsLoadedState(ride));
    } catch (e) {
      emit(RideDetailsErrorState(e.toString()));
    }
  }
}