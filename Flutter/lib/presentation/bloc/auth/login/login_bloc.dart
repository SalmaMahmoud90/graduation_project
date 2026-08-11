import 'dart:async';
import 'dart:developer';

import 'package:a_tareqaak/presentation/bloc/auth/login/i_login_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/login/i_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/token/tokens_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';


// 👈 بلوك تسجيل الدخول المطابق للنموذج القياسي
class LoginBloc extends Bloc<ILoginEvent, ILoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>(_login);
  }

  FutureOr<void> _login(LoginEvent event, Emitter<ILoginState> emit) async {
    emit(LoginLoading());
    try {
      final result = await locator<
          IUseCase<BaseModel<TokensModel>?, LoginEntity>>(
        instanceName: 'LoginUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(LoginFailed(l.message)),
        (r) => emit(LoginLoaded(tokensModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(LoginFailed(e.toString()));
    }
  }
}