import 'package:a_tareqaak/data/data_source/rides/rides_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:a_tareqaak/domain/repository/rides/i_rides_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable(as: IRidesRepository)
class RidesRepository implements IRidesRepository {
  final RidesRemoteDataSource _remoteDataSource;

  RidesRepository(this._remoteDataSource);

  @override
  Future<Either<AppException, BaseModel<RideDataModel>?>> createRide(
          CreateRideEntity data) =>
      _remoteDataSource.createRide(data);

  @override
  Future<Either<AppException, BaseModel<RideDataModel>?>> updateRide(
          UpdateRideEntity data) =>
      _remoteDataSource.updateRide(data);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> cancelRide(IdEntity data) =>
      _remoteDataSource.cancelRide(data);

  @override
  Future<Either<AppException, BaseModel<ReservationDataModel>?>>
      createReservation(CreateReservationEntity data) =>
          _remoteDataSource.createReservation(data);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> cancelReservation(
          IdEntity data) =>
      _remoteDataSource.cancelReservation(data);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> acceptReservation(
          IdEntity data) =>
      _remoteDataSource.acceptReservation(data);

  @override
  Future<Either<AppException, BaseModel<dynamic>?>> rejectReservation(
          IdEntity data) =>
      _remoteDataSource.rejectReservation(data);

  @override
  Future<Either<AppException, BaseModel<RidesListModel>?>> searchRides(
          SearchRidesEntity data) =>
      _remoteDataSource.searchRides(data);

  @override
  Future<Either<AppException, BaseModel<RidesListModel>?>> myRides() =>
      _remoteDataSource.myRides();

  @override
  Future<Either<AppException, BaseModel<ReservationsListModel>?>>
      myReservations() => _remoteDataSource.myReservations();

  @override
  Future<Either<AppException, BaseModel<RideDetailsModel>?>> rideDetails(
          IdEntity data) =>
      _remoteDataSource.rideDetails(data);
}
