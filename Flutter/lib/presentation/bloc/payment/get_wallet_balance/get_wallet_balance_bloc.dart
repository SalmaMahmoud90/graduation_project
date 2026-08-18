import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/presentation/bloc/payment/get_wallet_balance/i_get_wallet_balance_event.dart';
import 'package:a_tareqaak/presentation/bloc/payment/get_wallet_balance/i_get_wallet_balance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/entity/rides/rides_no_params_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


// بلوك جلب رصيد المحفظة من الـ API
class GetWalletBalanceBloc
    extends Bloc<IGetWalletBalanceEvent, IGetWalletBalanceState> {
  GetWalletBalanceBloc() : super(GetWalletBalanceInitial()) {
    on<GetWalletBalanceEvent>(_getBalance);
  }

  FutureOr<void> _getBalance(
    GetWalletBalanceEvent event,
    Emitter<IGetWalletBalanceState> emit,
  ) async {
    emit(GetWalletBalanceLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<WalletBalanceModel>?, RidesNoParamsEntity>>(
        instanceName: 'GetWalletBalanceUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(GetWalletBalanceFailed(l.message)),
        (r) => emit(GetWalletBalanceLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(GetWalletBalanceFailed(e.toString()));
    }
  }
}