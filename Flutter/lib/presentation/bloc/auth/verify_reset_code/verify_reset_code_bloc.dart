import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/auth/verify_reset_code/i_verify_reset_code_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/verify_reset_code/i_verify_reset_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


class VerifyResetCodeBloc
    extends Bloc<IVerifyResetCodeEvent, IVerifyResetCodeState> {
  VerifyResetCodeBloc() : super(VerifyResetCodeInitial()) {
    on<VerifyResetCodeEvent>(_verifyResetCode);
  }

  FutureOr<void> _verifyResetCode(
    VerifyResetCodeEvent event,
    Emitter<IVerifyResetCodeState> emit,
  ) async {
    emit(VerifyResetCodeLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<UserModel>?, VerifyResetCodeEntity>>(
        instanceName: 'VerifyResetCodeUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(VerifyResetCodeFailed(l.message)),
        (r) => emit(VerifyResetCodeLoaded(userModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(VerifyResetCodeFailed(e.toString()));
    }
  }
}