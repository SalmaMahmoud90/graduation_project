import 'package:a_tareqaak/data/models/auth/forgot_password_response/forgot_password_response_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/forgot_password/forgot_password_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام نسيت كلمة المرور
@Injectable(
    as: IUseCase<BaseModel<ForgotPasswordResponseModel>?,
        ForgotPasswordEntity>)
@Named('ForgotPasswordUseCase')
class ForgotPasswordUseCase
    implements
        IUseCase<BaseModel<ForgotPasswordResponseModel>?,
            ForgotPasswordEntity> {
  final IAuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<ForgotPasswordResponseModel>?>> call(
      ForgotPasswordEntity data) {
    return _repository.forgotPassword(data);
  }
}