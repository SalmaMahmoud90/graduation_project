import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/reset_password/reset_password_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام إعادة تعيين كلمة المرور الجديدة
@Injectable(as: IUseCase<BaseModel<UserModel>?, ResetPasswordEntity>)
@Named('ResetPasswordUseCase')
class ResetPasswordUseCase
    implements IUseCase<BaseModel<UserModel>?, ResetPasswordEntity> {
  final IAuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      ResetPasswordEntity data) {
    return _repository.resetPassword(data);
  }
}