import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/report/get_report_details/i_get_report_details_event.dart';
import 'package:a_tareqaak/presentation/bloc/report/get_report_details/i_get_report_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

class GetReportDetailsBloc
    extends Bloc<IGetReportDetailsEvent, IGetReportDetailsState> {
  GetReportDetailsBloc() : super(GetReportDetailsInitial()) {
    on<GetReportDetailsEvent>(_getReportDetails);
  }

  FutureOr<void> _getReportDetails(
    GetReportDetailsEvent event,
    Emitter<IGetReportDetailsState> emit,
  ) async {
    emit(GetReportDetailsLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<ReportDataModel>?, IdEntity>>(
        instanceName: 'GetReportDetailsUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(GetReportDetailsFailed(l.message)),
        (r) => emit(GetReportDetailsLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(GetReportDetailsFailed(e.toString()));
    }
  }
}
