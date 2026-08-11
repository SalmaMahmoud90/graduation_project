import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:a_tareqaak/domain/repository/rides/i_rides_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IUseCase<BaseModel<RideDataModel>?, UpdateRideEntity>)
@Named('UpdateRideUseCase')
class UpdateRideUseCase
    implements IUseCase<BaseModel<RideDataModel>?, UpdateRideEntity> {
  final IRidesRepository _repository;
  UpdateRideUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<RideDataModel>?>> call(
          UpdateRideEntity data) =>
      _repository.updateRide(data);
}
