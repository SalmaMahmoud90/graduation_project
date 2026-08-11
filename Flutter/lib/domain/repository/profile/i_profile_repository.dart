import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/profile/profile_model.dart';
import 'package:a_tareqaak/domain/entity/profile/update_driver_profile_entity.dart';
import 'package:a_tareqaak/domain/entity/profile/update_rider_profile_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

abstract interface class IProfileRepository {
  Future<Either<AppException, BaseModel<ProfileModel>?>> viewProfile();
  Future<Either<AppException, BaseModel<dynamic>?>> updateDriverProfile(
      UpdateDriverProfileEntity data);
  Future<Either<AppException, BaseModel<dynamic>?>> updateRiderProfile(
      UpdateRiderProfileEntity data);
}
