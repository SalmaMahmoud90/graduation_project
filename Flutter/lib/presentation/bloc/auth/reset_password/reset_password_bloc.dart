import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/presentation/bloc/auth/reset_password/i_reset_password_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/reset_password/i_reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';



// بلوك طلب تغيير كلمة المرور بـ API
class ResetPasswordBloc extends Bloc<IResetPasswordEvent, IResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordEvent>(_resetPassword);
  }

  FutureOr<void> _resetPassword(
      ResetPasswordEvent event, Emitter<IResetPasswordState> emit) async {
    emit(ResetPasswordLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<UserModel>?, ResetPasswordEntity>>(
        instanceName: 'ResetPasswordUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(ResetPasswordFailed(l.message)),
        (r) => emit(ResetPasswordLoaded(userModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(ResetPasswordFailed(e.toString()));
    }
  }
}