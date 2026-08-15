import 'package:a_tareqaak/data/data_source/auth/auth_remote_data_source.dart';
import 'package:a_tareqaak/data/models/auth/forgot_password_response/forgot_password_response_model.dart';
import 'package:a_tareqaak/data/models/auth/token/tokens_model.dart';
import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_reset_password/resend_reset_password.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_verification/resend_verification_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';

// تنفيذ مستودع الـ Auth الكامل
@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> register(RegisterEntity data) {
    return _remoteDataSource.register(data);
  }

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> verifyEmail(VerifyEmailEntity data) {
    return _remoteDataSource.verifyEmail(data);
  }

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> resendVerification(ResendVerificationEntity data) {
    return _remoteDataSource.resendVerification(data);
  }

  @override
  Future<Either<AppException, BaseModel<TokensModel>?>> login(LoginEntity data) {
    return _remoteDataSource.login(data);
  }

  @override
  Future<Either<AppException, BaseModel<ForgotPasswordResponseModel>?>> forgotPassword(ForgotPasswordEntity data) {
    return _remoteDataSource.forgotPassword(data);
  }

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> verifyResetCode(VerifyResetCodeEntity data) {
    return _remoteDataSource.verifyResetCode(data);
  }

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> resetPassword(ResetPasswordEntity data) {
    return _remoteDataSource.resetPassword(data);
  }

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> resendResetPassword(ResendResetPasswordEntity data) {
    return _remoteDataSource.resendResetPassword(data);
  }


  @override
  Future<Either<AppException, BaseModel<UserModel>?>> logout() {
    return _remoteDataSource.logout();
  }
}