import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/domain/entity/payment/payment_entity.dart';
import 'package:a_tareqaak/presentation/bloc/payment/create_deposit_request/i_create_deposit_request_event.dart';
import 'package:a_tareqaak/presentation/bloc/payment/create_deposit_request/i_create_deposit_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/payment/payment_models.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class CreateDepositRequestBloc extends Bloc<ICreateDepositRequestEvent, ICreateDepositRequestState> {
  CreateDepositRequestBloc() : super(CreateDepositRequestInitial()) {
    on<CreateDepositRequestEvent>(_createDepositRequest);
  }

  FutureOr<void> _createDepositRequest(
    CreateDepositRequestEvent event,
    Emitter<ICreateDepositRequestState> emit,
  ) async {
    emit(CreateDepositRequestLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<DepositRequestDataModel>?, CreateDepositRequestEntity>>(
        instanceName: 'CreateDepositRequestUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(CreateDepositRequestFailed(l.message)),
        (r) => emit(CreateDepositRequestLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(CreateDepositRequestFailed(e.toString()));
    }
  }
}