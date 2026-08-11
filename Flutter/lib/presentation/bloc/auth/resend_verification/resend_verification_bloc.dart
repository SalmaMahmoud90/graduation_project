import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/auth/resend_verification/i_resend_verification_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/resend_verification/i_resend_verification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_verification/resend_verification_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

class ResendVerificationBloc
    extends Bloc<IResendVerificationEvent, IResendVerificationState> {
  ResendVerificationBloc() : super(ResendVerificationInitial()) {
    on<ResendVerificationEvent>(_resendVerification);
  }

  FutureOr<void> _resendVerification(
    ResendVerificationEvent event,
    Emitter<IResendVerificationState> emit,
  ) async {
    emit(ResendVerificationLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<UserModel>?, ResendVerificationEntity>>(
        instanceName: 'ResendVerificationUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(ResendVerificationFailed(l.message)),
        (r) => emit(ResendVerificationLoaded(userModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(ResendVerificationFailed(e.toString()));
    }
  }
}