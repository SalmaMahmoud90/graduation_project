import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/logout/logout_entity.dart';
import 'package:a_tareqaak/presentation/bloc/auth/logout/i_logout_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/logout/i_logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// بلوك تسجيل الخروج
class LogoutBloc extends Bloc<ILogoutEvent, ILogoutState> {
  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutSubmitEvent>(_logout);
  }

  FutureOr<void> _logout(
    LogoutSubmitEvent event,
    Emitter<ILogoutState> emit,
  ) async {
    emit(LogoutLoading());
    try {
      final result =
          await locator<IUseCase<BaseModel<UserModel>?, LogoutEntity>>(
        instanceName: 'LogoutUseCase',
      )(const LogoutEntity());

      result.fold(
        (l) => emit(LogoutFailed(l.message)),
        (r) => emit( LogoutSuccess()),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(LogoutFailed(e.toString()));
    }
  }
}