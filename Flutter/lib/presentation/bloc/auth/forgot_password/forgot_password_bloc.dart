import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/auth/forgot_password/i_forgot_password_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/forgot_password/i_forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/forgot_password_response/forgot_password_response_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


// بلوك طلب نسيت كلمة المرور
class ForgotPasswordBloc
    extends Bloc<IForgotPasswordEvent, IForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEvent>(_forgotPassword);
  }

  FutureOr<void> _forgotPassword(
    ForgotPasswordEvent event,
    Emitter<IForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<ForgotPasswordResponseModel>?,
              ForgotPasswordEntity>>(
        instanceName: 'ForgotPasswordUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(ForgotPasswordFailed(l.message)),
        (r) => emit(ForgotPasswordLoaded(responseModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(ForgotPasswordFailed(e.toString()));
    }
  }
}