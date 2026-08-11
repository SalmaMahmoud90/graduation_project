import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:a_tareqaak/domain/repository/rides/i_rides_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(
    as: IUseCase<BaseModel<ReservationDataModel>?, CreateReservationEntity>)
@Named('CreateReservationUseCase')
class CreateReservationUseCase
    implements
        IUseCase<BaseModel<ReservationDataModel>?, CreateReservationEntity> {
  final IRidesRepository _repository;
  CreateReservationUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<ReservationDataModel>?>> call(
          CreateReservationEntity data) =>
      _repository.createReservation(data);
}
