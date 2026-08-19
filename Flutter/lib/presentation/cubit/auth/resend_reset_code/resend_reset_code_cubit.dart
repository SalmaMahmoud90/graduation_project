import 'package:a_tareqaak/domain/entity/auth/resend_reset_code/resend_reset_code.dart';
import 'package:a_tareqaak/presentation/cubit/auth/resend_reset_code/resend_reset_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendResetCodeCubit extends Cubit<ResendResetCodeCubitState> {
  ResendResetCodeCubit()
      : super(const ResendResetCodeCubitState(entity: null));

  void resetTokenChanged(String resetToken) {
    emit(state.copyWith(entity: ResendResetCodeEntity(resetToken: resetToken)));
  }
}
