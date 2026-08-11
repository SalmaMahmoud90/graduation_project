import 'package:a_tareqaak/data/models/auth/user/user_model.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/auth/resend_verification/resend_verification_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/domain/repository/auth/i_auth_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

// حالة استخدام إعادة إرسال كود التحقق
@Injectable(as: IUseCase<BaseModel<UserModel>?, ResendVerificationEntity>)
@Named('ResendVerificationUseCase')
class ResendVerificationUseCase
    implements IUseCase<BaseModel<UserModel>?, ResendVerificationEntity> {
  final IAuthRepository _repository;

  ResendVerificationUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<UserModel>?>> call(
      ResendVerificationEntity data) {
    return _repository.resendVerification(data);
  }
}