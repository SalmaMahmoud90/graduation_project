import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/payment/get_transaction/i_get_transactions_event.dart';
import 'package:a_tareqaak/presentation/bloc/payment/get_transaction/i_get_transactions_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

class GetTransactionsBloc
    extends Bloc<IGetTransactionsEvent, IGetTransactionsState> {
  GetTransactionsBloc() : super(GetTransactionsInitial()) {
    on<GetTransactionsEvent>(_getTransactions);
  }

  FutureOr<void> _getTransactions(
    GetTransactionsEvent event,
    Emitter<IGetTransactionsState> emit,
  ) async {
    emit(GetTransactionsLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<TransactionsListModel>?, RidesNoParamsEntity>>(
        instanceName: 'GetTransactionsUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(GetTransactionsFailed(l.message)),
        (r) => emit(GetTransactionsLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(GetTransactionsFailed(e.toString()));
    }
  }
}