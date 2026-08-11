import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام التحقق من رمز إعادة التعيين
@Injectable(as: IUseCase<BaseModel<UserModel>?, VerifyResetCodeEntity>)
@Named('VerifyResetCodeUseCase')
class VerifyResetCodeUseCase
    implements IUseCase<BaseModel<UserModel>?, VerifyResetCodeEntity> {
  final IAuthRepository _repository;

  VerifyResetCodeUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      VerifyResetCodeEntity data) {
    return _repository.verifyResetCode(data);
  }
}