import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:a_tareqaak/domain/repository/rides/i_rides_repository.dart';
import 'package:a_tareqaak/domain/usecase/i_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IUseCase<BaseModel<RidesListModel>?, SearchRidesEntity>)
@Named('SearchRidesUseCase')
class SearchRidesUseCase
    implements IUseCase<BaseModel<RidesListModel>?, SearchRidesEntity> {
  final IRidesRepository _repository;
  SearchRidesUseCase(this._repository);

  @override
  Future<Either<AppException, BaseModel<RidesListModel>?>> call(
          SearchRidesEntity data) =>
      _repository.searchRides(data);
}
