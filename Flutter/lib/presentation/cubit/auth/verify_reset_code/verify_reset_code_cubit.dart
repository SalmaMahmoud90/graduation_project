import 'package:a_tareqaak/presentation/cubit/auth/verify_reset_code/verify_reset_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';


class VerifyResetCodeCubit extends Cubit<VerifyResetCodeCubitState> {
  VerifyResetCodeCubit(String resetToken)
      : super(VerifyResetCodeCubitState(
          entity: VerifyResetCodeEntity(resetToken: resetToken, code: ''),
        ));

  void codeChanged(String code) {
    final current = state.entity ??
        const VerifyResetCodeEntity(resetToken: '', code: '');
    emit(
      state.copyWith(
        entity: VerifyResetCodeEntity(
          resetToken: current.resetToken,
          code: code,
        ),
      ),
    );
  }
}