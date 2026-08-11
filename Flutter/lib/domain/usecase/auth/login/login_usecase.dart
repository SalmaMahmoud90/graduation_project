import 'package:a_tareqaak/data/models/auth/token/tokens_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام تسجيل الدخول
@Injectable(as: IUseCase<BaseModel<TokensModel>?, LoginEntity>)
@Named('LoginUseCase')
class LoginUseCase
    implements IUseCase<BaseModel<TokensModel>?, LoginEntity> {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<TokensModel>?>> call(
      LoginEntity data) {
    return _repository.login(data);
  }
}