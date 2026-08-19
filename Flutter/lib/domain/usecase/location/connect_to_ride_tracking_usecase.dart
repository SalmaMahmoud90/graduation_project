import 'package:a_tareqaak/domain/entity/location/ride_tracking_connection_entity.dart';
import 'package:a_tareqaak/domain/repository/location/i_ride_tracking_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<Unit, RideTrackingConnectionEntity>)
@Named('ConnectToRideTrackingUseCase')
class ConnectToRideTrackingUseCase
    implements IUseCase<Unit, RideTrackingConnectionEntity> {
  final IRideTrackingRepository _repository;

  ConnectToRideTrackingUseCase(this._repository);

  @override
  Future<Either<AppException, Unit>> call(RideTrackingConnectionEntity data) {
    return _repository.connectToRide(data);
  }
}