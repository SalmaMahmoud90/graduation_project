import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/profile/profile_model.dart';
import 'package:a_tareqaak/domain/entity/profile/view_profile_entity.dart';
import 'package:a_tareqaak/domain/repository/profile/i_profile_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IUseCase<BaseModel<ProfileModel>?, ViewProfileEntity>)
@Named('ViewProfileUseCase')
class ViewProfileUseCase
    implements IUseCase<BaseModel<ProfileModel>?, ViewProfileEntity> {
  final IProfileRepository _repository;

  ViewProfileUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<ProfileModel>?>> call(
      ViewProfileEntity data) {
    return _repository.viewProfile();
  }
}
