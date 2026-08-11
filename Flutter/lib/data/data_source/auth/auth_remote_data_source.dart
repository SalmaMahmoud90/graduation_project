import 'package:a_tareqaak/core/constants/api_endpoints.dart';
import 'package:a_tareqaak/data/data_source/base/base_remote_data_source.dart';
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
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable()
class AuthRemoteDataSource extends BaseRemoteDataSource<dynamic> {
  AuthRemoteDataSource() : super('/users');

  // 1. إنشاء حساب جديد
  Future<Either<AppException, BaseModel<UserModel>?>> register(
    RegisterEntity data,
  ) {
    return postData<UserModel>(
      endpoint: ApiEndpoints.create,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 2. التحقق من البريد الإلكتروني
  Future<Either<AppException, BaseModel<UserModel>?>> verifyEmail(
    VerifyEmailEntity data,
  ) {
    debugPrint('🚨 VERIFY EMAIL CALLED');
  debugPrint('🚨 endpoint: ${ApiEndpoints.verifyEmail}');
  debugPrint('🚨 data: ${data.toJson()}');
    return postData<UserModel>(
      endpoint: ApiEndpoints.verifyEmail,
      data: data.toJson(),
      isFormDate: false,
    );
  }

  // 3. إعادة إرسال رمز التحقق
  Future<Either<AppException, BaseModel<UserModel>?>> resendVerification(
    ResendVerificationEntity data,
  ) {
    return postData<UserModel>(
      endpoint: ApiEndpoints.resendVerification,
      data: data.toJson(),
      isFormDate: false,
    );
  }

  // 4. تسجيل الدخول
  Future<Either<AppException, BaseModel<TokensModel>?>> login(
    LoginEntity data,
  ) {
    return postData<TokensModel>(
      endpoint: ApiEndpoints.login,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          TokensModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // 5. نسيت كلمة المرور
  Future<Either<AppException, BaseModel<ForgotPasswordResponseModel>?>>
      forgotPassword(
    ForgotPasswordEntity data,
  ) {
    return postData<ForgotPasswordResponseModel>(
      endpoint: ApiEndpoints.forgotPassword,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          ForgotPasswordResponseModel.fromJson(
            json as Map<String, dynamic>,
          ),
    );
  }

  // 6. التحقق من رمز إعادة تعيين كلمة المرور
  Future<Either<AppException, BaseModel<UserModel>?>> verifyResetCode(
    VerifyResetCodeEntity data,
  ) {
    debugPrint('🔥 VERIFY RESET CODE CALLED');
  debugPrint('🔥 endpoint: ${ApiEndpoints.verifyResetCode}');
  debugPrint('🔥 data: ${data.toJson()}');
    return postData<UserModel>(
      endpoint: ApiEndpoints.verifyResetCode,
      data: data.toJson(),
      isFormDate: false,
    );
  }

  // 7. إعادة تعيين كلمة المرور
  Future<Either<AppException, BaseModel<UserModel>?>> resetPassword(
    ResetPasswordEntity data,
  ) {
    return postData<UserModel>(
      endpoint: ApiEndpoints.resetPassword,
      data: data.toJson(),
      isFormDate: false,
    );
  }

  // 8. تسجيل الخروج
  Future<Either<AppException, BaseModel<UserModel>?>> logout() {
    return postData<UserModel>(
      endpoint: ApiEndpoints.logout,
      isFormDate: false,
    );
  }
}