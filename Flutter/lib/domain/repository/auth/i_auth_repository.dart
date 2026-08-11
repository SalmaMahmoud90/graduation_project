import 'package:a_tareqaak/data/models/auth/forgot_password_response/forgot_password_response_model.dart';
import 'package:a_tareqaak/data/models/auth/token/tokens_model.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_verification/resend_verification_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

// واجهة مستودع الـ Auth الشاملة
abstract interface class IAuthRepository {
  Future<Either<AppException, BaseModel<UserModel>?>> register(RegisterEntity data);
  Future<Either<AppException, BaseModel<UserModel>?>> verifyEmail(VerifyEmailEntity data);
  Future<Either<AppException, BaseModel<UserModel>?>> resendVerification(ResendVerificationEntity data);
  Future<Either<AppException, BaseModel<TokensModel>?>> login(LoginEntity data);
  Future<Either<AppException, BaseModel<ForgotPasswordResponseModel>?>> forgotPassword(ForgotPasswordEntity data);
  Future<Either<AppException, BaseModel<UserModel>?>> verifyResetCode(VerifyResetCodeEntity data);
  Future<Either<AppException, BaseModel<UserModel>?>> resetPassword(ResetPasswordEntity data);
  Future<Either<AppException, BaseModel<UserModel>?>> logout();
}