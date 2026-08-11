import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/profile/update_driver_profile_entity.dart';
import 'package:a_tareqaak/domain/repository/profile/i_profile_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IUseCase<BaseModel<dynamic>?, UpdateDriverProfileEntity>)
@Named('UpdateDriverProfileUseCase')
class UpdateDriverProfileUseCase
    implements IUseCase<BaseModel<dynamic>?, UpdateDriverProfileEntity> {
  final IProfileRepository _repository;

  UpdateDriverProfileUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> call(
      UpdateDriverProfileEntity data) {
    return _repository.updateDriverProfile(data);
  }
}
