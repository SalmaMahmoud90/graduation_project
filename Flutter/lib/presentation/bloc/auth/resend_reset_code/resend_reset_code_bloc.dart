import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/auth/resend_reset_code/i_resend_reset_code_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/resend_reset_code/i_resend_reset_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_reset_code/resend_reset_code.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

class ResendResetCodeBloc
    extends Bloc<IResendResetCodeEvent, IResendResetCodeState> {
  ResendResetCodeBloc() : super(ResendResetCodeInitial()) {
    on<ResendResetCodeEvent>(_resendResetCode);
  }

  FutureOr<void> _resendResetCode(
    ResendResetCodeEvent event,
    Emitter<IResendResetCodeState> emit,
  ) async {
    emit(ResendResetCodeLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<UserModel>?, ResendResetCodeEntity>>(
        instanceName: 'ResendResetCodeUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(ResendResetCodeFailed(l.message)),
        (r) => emit(ResendResetCodeLoaded(userModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(ResendResetCodeFailed(e.toString()));
    }
  }
}
