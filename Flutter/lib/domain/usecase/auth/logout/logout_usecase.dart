import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/logout/logout_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام تسجيل الخروج
@Injectable(as: IUseCase<BaseModel<UserModel>?, LogoutEntity>)
@Named('LogoutUseCase')
class LogoutUseCase
    implements IUseCase<BaseModel<UserModel>?, LogoutEntity> {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      LogoutEntity data) {
    return _repository.logout();
  }
}