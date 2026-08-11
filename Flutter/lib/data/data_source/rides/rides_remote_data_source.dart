import 'package:a_tareqaak/core/constants/api_endpoints.dart';
import 'package:a_tareqaak/data/data_source/base/base_remote_data_source.dart';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/reservation_data_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:a_tareqaak/domain/entity/rides/create_reservation_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/create_ride_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:a_tareqaak/domain/entity/rides/update_ride_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

@Injectable()
class RidesRemoteDataSource extends BaseRemoteDataSource<dynamic> {
  RidesRemoteDataSource() : super(ApiEndpoints.rides);

  // إنشاء رحلة (POST /rides/create/)
  Future<Either<AppException, BaseModel<RideDataModel>?>> createRide(
    CreateRideEntity data,
  ) {
    return postData<RideDataModel>(
      endpoint: ApiEndpoints.ridesCreate,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          RideDataModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // تحديث رحلة (PATCH /rides/<id>/update/)
  Future<Either<AppException, BaseModel<RideDataModel>?>> updateRide(
    UpdateRideEntity data,
  ) {
    return patchData<RideDataModel>(
      endpoint: ApiEndpoints.rideUpdate(data.id),
      data: data.toJson(),
      isFormData: false,
      fromJsonT: (json) =>
          RideDataModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // إلغاء رحلة (DELETE /rides/<id>/cancel/)
  Future<Either<AppException, BaseModel<dynamic>?>> cancelRide(IdEntity data) {
    return deleteData(endpoint: ApiEndpoints.rideCancel(data.id));
  }

  // إنشاء حجز (POST /rides/reservations/create/)
  Future<Either<AppException, BaseModel<ReservationDataModel>?>>
      createReservation(CreateReservationEntity data) {
    return postData<ReservationDataModel>(
      endpoint: ApiEndpoints.reservationsCreate,
      data: data.toJson(),
      isFormDate: false,
      fromJsonT: (json) =>
          ReservationDataModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // إلغاء حجز (POST /rides/reservations/<id>/cancel/)
  Future<Either<AppException, BaseModel<dynamic>?>> cancelReservation(
    IdEntity data,
  ) {
    return postData(
      endpoint: ApiEndpoints.reservationCancel(data.id),
      isFormDate: false,
    );
  }

  // قبول حجز (POST /rides/reservations/<id>/accept/)
  Future<Either<AppException, BaseModel<dynamic>?>> acceptReservation(
    IdEntity data,
  ) {
    return postData(
      endpoint: ApiEndpoints.reservationAccept(data.id),
      isFormDate: false,
    );
  }

  // رفض حجز (POST /rides/reservations/<id>/reject/)
  Future<Either<AppException, BaseModel<dynamic>?>> rejectReservation(
    IdEntity data,
  ) {
    return postData(
      endpoint: ApiEndpoints.reservationReject(data.id),
      isFormDate: false,
    );
  }

  // البحث عن رحلات (GET /rides/search/?location=&destination=)
  Future<Either<AppException, BaseModel<RidesListModel>?>> searchRides(
    SearchRidesEntity data,
  ) {
    return fetchData<RidesListModel>(
      endpoint: ApiEndpoints.ridesSearch,
      queryParams: data.toQuery(),
      fromJsonT: (json) =>
          RidesListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // رحلاتي كسائق (GET /rides/my_rides/)
  Future<Either<AppException, BaseModel<RidesListModel>?>> myRides() {
    return fetchData<RidesListModel>(
      endpoint: ApiEndpoints.myRides,
      fromJsonT: (json) =>
          RidesListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // حجوزاتي كراكب (GET /rides/my_reservations/)
  Future<Either<AppException, BaseModel<ReservationsListModel>?>>
      myReservations() {
    return fetchData<ReservationsListModel>(
      endpoint: ApiEndpoints.myReservations,
      fromJsonT: (json) =>
          ReservationsListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // تفاصيل رحلة (GET /rides/ride_details/<id>/)
  Future<Either<AppException, BaseModel<RideDetailsModel>?>> rideDetails(
    IdEntity data,
  ) {
    return fetchData<RideDetailsModel>(
      endpoint: ApiEndpoints.rideDetails(data.id),
      fromJsonT: (json) =>
          RideDetailsModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
