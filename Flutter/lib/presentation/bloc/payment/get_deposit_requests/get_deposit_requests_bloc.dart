import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/payment/get_deposit_requests/i_get_deposit_requests_event.dart';
import 'package:a_tareqaak/presentation/bloc/payment/get_deposit_requests/i_get_deposit_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class GetDepositRequestsBloc
    extends Bloc<IGetDepositRequestsEvent, IGetDepositRequestsState> {
  GetDepositRequestsBloc() : super(GetDepositRequestsInitial()) {
    on<GetDepositRequestsEvent>(_getDepositRequests);
  }

  FutureOr<void> _getDepositRequests(
    GetDepositRequestsEvent event,
    Emitter<IGetDepositRequestsState> emit,
  ) async {
    emit(GetDepositRequestsLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<DepositRequestsListModel>?, RidesNoParamsEntity>>(
        instanceName: 'GetDepositRequestsUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(GetDepositRequestsFailed(l.message)),
        (r) => emit(GetDepositRequestsLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(GetDepositRequestsFailed(e.toString()));
    }
  }
}