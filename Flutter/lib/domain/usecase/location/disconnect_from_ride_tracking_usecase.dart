import 'package:a_tareqaak/domain/repository/location/i_ride_tracking_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<Unit, NoParams>)
@Named('DisconnectFromRideTrackingUseCase')
class DisconnectFromRideTrackingUseCase implements IUseCase<Unit, NoParams> {
  final IRideTrackingRepository _repository;

  DisconnectFromRideTrackingUseCase(this._repository);

  @override
  Future<Either<AppException, Unit>> call(NoParams data) {
    return _repository.disconnectFromRide();
  }
}