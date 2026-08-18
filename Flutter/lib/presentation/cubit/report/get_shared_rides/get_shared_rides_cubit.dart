import 'package:a_tareqaak/presentation/cubit/report/get_shared_rides/get_shared_rides_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';



class GetSharedRidesCubit extends Cubit<GetSharedRidesCubitState> {
  GetSharedRidesCubit() : super(const GetSharedRidesCubitState(entity: null));

  void setReportedUser(int userId) {
    emit(state.copyWith(entity: IdEntity(userId)));
  }
}