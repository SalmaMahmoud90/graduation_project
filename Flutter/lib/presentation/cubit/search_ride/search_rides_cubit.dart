import 'package:a_tareqaak/presentation/cubit/search_ride/search_rides_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';


// كيوبيت مدخلات نموذج البحث عن رحلات
class SearchRidesCubit extends Cubit<SearchRidesCubitState> {
  SearchRidesCubit() : super(const SearchRidesCubitState(entity: null));

  void locationChanged(String location) {
    final current = state.entity ?? const SearchRidesEntity(location: '', destination: '');
    emit(
      state.copyWith(
        entity: SearchRidesEntity(
          location: location,
          destination: current.destination,
        ),
      ),
    );
  }

  void destinationChanged(String destination) {
    final current = state.entity ?? const SearchRidesEntity(location: '', destination: '');
    emit(
      state.copyWith(
        entity: SearchRidesEntity(
          location: current.location,
          destination: destination,
        ),
      ),
    );
  }
}