import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_reset_code/resend_reset_code.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام إعادة إرسال كود التحقق
@Injectable(as: IUseCase<BaseModel<UserModel>?, ResendResetCodeEntity>)
@Named('ResendResetCodeUseCase')
class ResendResetCodeUseCase
    implements IUseCase<BaseModel<UserModel>?, ResendResetCodeEntity> {
  final IAuthRepository _repository;

  ResendResetCodeUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      ResendResetCodeEntity data) {
    return _repository.resendResetCode(data);
  }
}