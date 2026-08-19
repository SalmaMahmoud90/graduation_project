import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:a_tareqaak/domain/repository/location/i_ride_tracking_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

import 'package:a_tareqaak/domain/usecase/i_use_case.dart';

@Injectable(as: IUseCase<Unit, SendLocationEntity>)
@Named('SendLocationUseCase')
class SendLocationUseCase implements IUseCase<Unit, SendLocationEntity> {
  final IRideTrackingRepository _repository;

  SendLocationUseCase(this._repository);

  @override
  Future<Either<AppException, Unit>> call(SendLocationEntity data) {
    return _repository.sendLocation(data);
  }
}