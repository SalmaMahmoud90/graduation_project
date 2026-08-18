import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/domain/entity/report/report_entity.dart';
import 'package:a_tareqaak/presentation/bloc/report/create_report/i_create_report_event.dart';
import 'package:a_tareqaak/presentation/bloc/report/create_report/i_create_report_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/report/report_data_model.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

class CreateReportBloc extends Bloc<ICreateReportEvent, ICreateReportState> {
  CreateReportBloc() : super(CreateReportInitial()) {
    on<CreateReportEvent>(_createReport);
  }

  FutureOr<void> _createReport(
    CreateReportEvent event,
    Emitter<ICreateReportState> emit,
  ) async {
    emit(CreateReportLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<ReportDataModel>?, CreateReportEntity>>(
        instanceName: 'CreateReportUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(CreateReportFailed(l.message)),
        (r) => emit(CreateReportLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(CreateReportFailed(e.toString()));
    }
  }
}