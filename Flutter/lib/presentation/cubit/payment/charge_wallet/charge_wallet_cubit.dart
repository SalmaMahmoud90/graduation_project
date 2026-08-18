
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/presentation/cubit/payment/charge_wallet/charge_wallet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChargeWalletCubit extends Cubit<ChargeWalletCubitState> {
   ChargeWalletCubit() : super(const ChargeWalletCubitState(entity: null));

  void amountChanged(String amount) {
    _updateEntity(amount: amount);
  }

  void phoneChanged(String phone) {
    _updateEntity(transactionReference: phone);
  }

  void paymentMethodChanged(String method) {
    _updateEntity(paymentMethod: method);
  }

  void _updateEntity({String? amount, String? paymentMethod, String? transactionReference}) {
    final current = state.entity ?? const CreateDepositRequestEntity(amount: '50000', paymentMethod: 'syriatel_cash', transactionReference: '');
    emit(
      state.copyWith(
        entity: CreateDepositRequestEntity(
          amount: amount ?? current.amount,
          paymentMethod: paymentMethod ?? current.paymentMethod,
          transactionReference: transactionReference ?? current.transactionReference,
        ),
      ),
    );
  }
}