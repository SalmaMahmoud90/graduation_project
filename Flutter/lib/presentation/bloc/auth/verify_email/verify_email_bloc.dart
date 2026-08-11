import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/auth/verify_email/i_verify_email_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/verify_email/i_verify_email_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';



class VerifyEmailBloc extends Bloc<IVerifyEmailEvent, IVerifyEmailState> {
  VerifyEmailBloc() : super(VerifyEmailInitial()) {
    on<VerifyEmailEvent>(_verifyEmail);
  }

  FutureOr<void> _verifyEmail(
    VerifyEmailEvent event,
    Emitter<IVerifyEmailState> emit,
  ) async {
    emit(VerifyEmailLoading());
    try {
      final result =
          await locator<IUseCase<BaseModel<UserModel>?, VerifyEmailEntity>>(
        instanceName: 'VerifyEmailUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(VerifyEmailFailed(l.message)),
        (r) => emit(VerifyEmailLoaded(userModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(VerifyEmailFailed(e.toString()));
    }
  }
}