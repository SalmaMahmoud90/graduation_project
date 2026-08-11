import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/verify_email/verify_email_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام التحقق من البريد
@Injectable(as: IUseCase<BaseModel<UserModel>?, VerifyEmailEntity>)
@Named('VerifyEmailUseCase')
class VerifyEmailUseCase
    implements IUseCase<BaseModel<UserModel>?, VerifyEmailEntity> {
  final IAuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      VerifyEmailEntity data) {
    return _repository.verifyEmail(data);
  }
}