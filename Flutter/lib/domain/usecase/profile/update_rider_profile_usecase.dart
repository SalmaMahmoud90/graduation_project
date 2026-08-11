import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/profile/update_rider_profile_entity.dart';
import 'package:a_tareqaak/domain/repository/profile/i_profile_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IUseCase<BaseModel<dynamic>?, UpdateRiderProfileEntity>)
@Named('UpdateRiderProfileUseCase')
class UpdateRiderProfileUseCase
    implements IUseCase<BaseModel<dynamic>?, UpdateRiderProfileEntity> {
  final IProfileRepository _repository;

  UpdateRiderProfileUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> call(
      UpdateRiderProfileEntity data) {
    return _repository.updateRiderProfile(data);
  }
}
