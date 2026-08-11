import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

abstract interface class IRidesRepository {
  Future<Either<AppException, BaseModel<RideDataModel>?>> createRide(
      CreateRideEntity data);
  Future<Either<AppException, BaseModel<RideDataModel>?>> updateRide(
      UpdateRideEntity data);
  Future<Either<AppException, BaseModel<dynamic>?>> cancelRide(IdEntity data);
  Future<Either<AppException, BaseModel<ReservationDataModel>?>>
      createReservation(CreateReservationEntity data);
  Future<Either<AppException, BaseModel<dynamic>?>> cancelReservation(
      IdEntity data);
  Future<Either<AppException, BaseModel<dynamic>?>> acceptReservation(
      IdEntity data);
  Future<Either<AppException, BaseModel<dynamic>?>> rejectReservation(
      IdEntity data);
  Future<Either<AppException, BaseModel<RidesListModel>?>> searchRides(
      SearchRidesEntity data);
  Future<Either<AppException, BaseModel<RidesListModel>?>> myRides();
  Future<Either<AppException, BaseModel<ReservationsListModel>?>>
      myReservations();
  Future<Either<AppException, BaseModel<RideDetailsModel>?>> rideDetails(
      IdEntity data);
}
