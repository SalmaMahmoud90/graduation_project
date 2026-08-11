import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام إنشاء الحساب
@Injectable(as: IUseCase<BaseModel<UserModel>?, RegisterEntity>)
@Named('RegisterUseCase')
class RegisterUseCase
    implements IUseCase<BaseModel<UserModel>?, RegisterEntity> {
  final IAuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      RegisterEntity data) {
    return _repository.register(data);
  }
}