import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/report/get_my_reports/i_get_my_reports_event.dart';
import 'package:a_tareqaak/presentation/bloc/report/get_my_reports/i_get_my_reports_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class GetMyReportsBloc extends Bloc<IGetMyReportsEvent, IGetMyReportsState> {
  GetMyReportsBloc() : super(GetMyReportsInitial()) {
    on<GetMyReportsEvent>(_getMyReports);
  }

  FutureOr<void> _getMyReports(
    GetMyReportsEvent event,
    Emitter<IGetMyReportsState> emit,
  ) async {
    emit(GetMyReportsLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<ReportsListModel>?, RidesNoParamsEntity>>(
        instanceName: 'GetMyReportsUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(GetMyReportsFailed(l.message)),
        (r) => emit(GetMyReportsLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(GetMyReportsFailed(e.toString()));
    }
  }
}