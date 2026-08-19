import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:a_tareqaak/domain/entity/location/ride_tracking_connection_entity.dart';
import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';


abstract interface class IRideTrackingRepository {
  Future<Either<AppException, Unit>> connectToRide(RideTrackingConnectionEntity params);
  Future<Either<AppException, Unit>> sendLocation(SendLocationEntity data);
  Future<Either<AppException, Unit>> disconnectFromRide();
  Stream<LocationUpdateEntity> listenToLocationUpdates();
}