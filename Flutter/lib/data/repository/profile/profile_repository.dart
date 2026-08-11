import 'package:a_tareqaak/data/data_source/profile/profile_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/profile/profile_model.dart';
import 'package:a_tareqaak/domain/entity/profile/update_driver_profile_entity.dart';
import 'package:a_tareqaak/domain/entity/profile/update_rider_profile_entity.dart';
import 'package:a_tareqaak/domain/repository/profile/i_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IProfileRepository)
class ProfileRepository implements IProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  @override
  Future<Either<AppException, BaseModel<ProfileModel>?>> viewProfile() {
    return _remoteDataSource.viewProfile();
  }

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> updateDriverProfile(
      UpdateDriverProfileEntity data) {
    return _remoteDataSource.updateDriverProfile(data);
  }

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> updateRiderProfile(
      UpdateRiderProfileEntity data) {
    return _remoteDataSource.updateRiderProfile(data);
  }
}
