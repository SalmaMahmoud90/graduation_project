// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../data/data_source/auth/auth_remote_data_source.dart' as _i319;
import '../../../data/data_source/auth/auth_storage_data_source.dart' as _i300;
import '../../../data/models/auth/forgot_password_response/forgot_password_response_model.dart'
    as _i402;
import '../../../data/models/auth/token/tokens_model.dart' as _i9;
import '../../../data/models/auth/user/user_model.dart' as _i1011;
import '../../../data/models/base/base_model.dart' as _i480;
import '../../../data/repository/auth/auth_repository.dart' as _i728;
import '../../../domain/entity/auth/forgot_password/forgot_password_entity.dart'
    as _i146;
import '../../../domain/entity/auth/login/login_entity.dart' as _i27;
import '../../../domain/entity/auth/logout/logout_entity.dart' as _i385;
import '../../../domain/entity/auth/register/register_entity.dart' as _i811;
import '../../../domain/entity/auth/resend_verification/resend_verification_entity.dart'
    as _i1012;
import '../../../domain/entity/auth/reset_password/reset_password_entity.dart'
    as _i854;
import '../../../domain/entity/auth/verify_email/verify_email_entity.dart'
    as _i592;
import '../../../domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart'
    as _i31;
import '../../../domain/repository/auth/i_auth_repository.dart' as _i154;
import '../../../domain/usecase/auth/forgot_password/forgot_password_usecase.dart'
    as _i854;
import '../../../domain/usecase/auth/login/login_usecase.dart' as _i710;
import '../../../domain/usecase/auth/logout/logout_usecase.dart' as _i638;
import '../../../domain/usecase/auth/register/register_usecase.dart' as _i523;
import '../../../domain/usecase/auth/resend_verification/resend_verification_usecase.dart'
    as _i1040;
import '../../../domain/usecase/auth/reset_password/reset_password_usecase.dart'
    as _i844;
import '../../../domain/usecase/auth/verify_email/verify_email_usecase.dart'
    as _i912;
import '../../../domain/usecase/auth/verify_reset_code/verify_reset_code_usecase.dart'
    as _i873;
import '../../../domain/usecase/i_use_case.dart' as _i759;
import '../../helper/local_storage_helper.dart' as _i218;
import '../../helper/network_helper.dart' as _i779;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i779.NetworkHelper>(() => _i779.NetworkHelper());
    gh.factory<_i319.AuthRemoteDataSource>(() => _i319.AuthRemoteDataSource());
    gh.factory<_i300.AuthStorageDataSource>(
      () => _i300.AuthStorageDataSource(),
    );
    gh.lazySingleton<_i218.LocalStorageHelper>(
      () => _i218.LocalStorageHelper(),
    );
    gh.factory<_i154.IAuthRepository>(
      () => _i728.AuthRepository(gh<_i319.AuthRemoteDataSource>()),
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i1012.ResendVerificationEntity
      >
    >(
      () => _i1040.ResendVerificationUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ResendVerificationUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i9.TokensModel>?, _i27.LoginEntity>
    >(
      () => _i710.LoginUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'LoginUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i854.ResetPasswordEntity
      >
    >(
      () => _i844.ResetPasswordUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ResetPasswordUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i402.ForgotPasswordResponseModel>?,
        _i146.ForgotPasswordEntity
      >
    >(
      () => _i854.ForgotPasswordUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ForgotPasswordUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i1011.UserModel>?, _i811.RegisterEntity>
    >(
      () => _i523.RegisterUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'RegisterUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i1011.UserModel>?, _i385.LogoutEntity>
    >(
      () => _i638.LogoutUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'LogoutUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i592.VerifyEmailEntity
      >
    >(
      () => _i912.VerifyEmailUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'VerifyEmailUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i31.VerifyResetCodeEntity
      >
    >(
      () => _i873.VerifyResetCodeUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'VerifyResetCodeUseCase',
    );
    return this;
  }
}
