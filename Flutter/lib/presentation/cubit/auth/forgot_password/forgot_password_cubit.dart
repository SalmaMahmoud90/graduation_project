import 'package:a_tareqaak/presentation/cubit/auth/forgot_password/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordCubitState> {
  ForgotPasswordCubit()
      : super(const ForgotPasswordCubitState(entity: null));

  void emailChanged(String email) {
    emit(state.copyWith(entity: ForgotPasswordEntity(email: email)));
  }
}