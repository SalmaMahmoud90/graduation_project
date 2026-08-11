import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/repository/rides/i_rides_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IUseCase<BaseModel<dynamic>?, IdEntity>)
@Named('AcceptReservationUseCase')
class AcceptReservationUseCase
    implements IUseCase<BaseModel<dynamic>?, IdEntity> {
  final IRidesRepository _repository;
  AcceptReservationUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> call(IdEntity data) =>
      _repository.acceptReservation(data);
}
