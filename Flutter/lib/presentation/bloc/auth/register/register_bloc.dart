import 'dart:async';
import 'dart:developer';
import 'package:a_tareqaak/presentation/bloc/auth/register/i_register_event.dart';
import 'package:a_tareqaak/presentation/bloc/auth/register/i_register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';



class RegisterBloc extends Bloc<IRegisterEvent, IRegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>(_register);
  }

  FutureOr<void> _register(
    RegisterEvent event,
    Emitter<IRegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final result =
          await locator<IUseCase<BaseModel<UserModel>?, RegisterEntity>>(
        instanceName: 'RegisterUseCase',
      )(event.entity);

      result.fold(
        (l) => emit(RegisterFailed(l.message)),
        (r) => emit(RegisterLoaded(userModel: r)),
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(RegisterFailed(e.toString()));
    }
  }
}