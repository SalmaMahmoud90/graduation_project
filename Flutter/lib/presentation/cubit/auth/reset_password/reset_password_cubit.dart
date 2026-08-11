
import 'package:a_tareqaak/presentation/cubit/auth/reset_password/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';


// كيوبيت نموذج إدخال كلمة المرور الجديدة
class ResetPasswordCubit extends Cubit<ResetPasswordCubitState> {
  ResetPasswordCubit(String resetToken)
      : super(ResetPasswordCubitState(
          entity: ResetPasswordEntity(
            resetToken: resetToken,
            newPassword: '',
            confirmPassword: '',
          ),
        ));

  void newPasswordChanged(String newPassword) {
    final current = state.entity ??
        const ResetPasswordEntity(
          resetToken: '',
          newPassword: '',
          confirmPassword: '',
        );
    emit(
      state.copyWith(
        entity: ResetPasswordEntity(
          resetToken: current.resetToken,
          newPassword: newPassword,
          confirmPassword: current.confirmPassword,
        ),
      ),
    );
  }

  void confirmPasswordChanged(String confirmPassword) {
    final current = state.entity ??
        const ResetPasswordEntity(
          resetToken: '',
          newPassword: '',
          confirmPassword: '',
        );
    emit(
      state.copyWith(
        entity: ResetPasswordEntity(
          resetToken: current.resetToken,
          newPassword: current.newPassword,
          confirmPassword: confirmPassword,
        ),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }
}