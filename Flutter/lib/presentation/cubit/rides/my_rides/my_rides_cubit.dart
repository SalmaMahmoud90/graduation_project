import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_rides_state.dart';

// كيوبيت جلب رحلات السائق (my_rides)
class MyRidesCubit extends Cubit<MyRidesState> {
  MyRidesCubit() : super(MyRidesInitial());

  Future<void> load() async {
    emit(MyRidesLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<RidesListModel>?, RidesNoParamsEntity>>(
        instanceName: 'MyRidesUseCase',
      )(const RidesNoParamsEntity());

      result.fold(
        (l) => emit(MyRidesError(l.message)),
        (r) => emit(MyRidesLoaded(r?.data?.rides ?? const [])),
      );
    } catch (e) {
      emit(MyRidesError(e.toString()));
    }
  }
}
