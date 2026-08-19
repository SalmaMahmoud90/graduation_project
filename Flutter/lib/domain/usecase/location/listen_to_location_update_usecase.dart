import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:a_tareqaak/domain/repository/location/i_ride_tracking_repository.dart';
import 'package:injectable/injectable.dart';


@Injectable()
class ListenToLocationUpdatesUseCase {
  final IRideTrackingRepository _repository;

  ListenToLocationUpdatesUseCase(this._repository);

  Stream<LocationUpdateEntity> call() {
    return _repository.listenToLocationUpdates();
  }
}