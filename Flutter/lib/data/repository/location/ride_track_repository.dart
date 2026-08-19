import 'dart:async';
import 'package:a_tareqaak/core/constants/app_storage_paths.dart';
import 'package:a_tareqaak/data/data_source/location/location_websocket_data_source.dart';
import 'package:a_tareqaak/domain/entity/location/location_update_entity.dart';
import 'package:a_tareqaak/domain/entity/location/ride_tracking_connection_entity.dart';
import 'package:a_tareqaak/domain/entity/location/send_location_entity.dart';
import 'package:a_tareqaak/domain/repository/location/i_ride_tracking_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/core/helper/local_storage_helper.dart';


@Injectable(as: IRideTrackingRepository)
class RideTrackingRepository implements IRideTrackingRepository {
  final LocationWebSocketDataSource _webSocketDataSource;
  final LocalStorageHelper _localStorageHelper;

  RideTrackingRepository(
    this._webSocketDataSource,
    this._localStorageHelper,
  );

  @override
  Future<Either<AppException, Unit>> connectToRide(
    RideTrackingConnectionEntity params,
  ) async {
    String? token = params.token;
    if (token == null || token.isEmpty) {
      final tokenResult = await _localStorageHelper.getValue(
        'auth_box',
        AppStoragePaths.token,
      );
      token = tokenResult.fold((l) => null, (r) => r?.toString());
    }

    if (token == null || token.isEmpty) {
      return Left(AppException('غير مصرح لك، يرجى تسجيل الدخول مجدداً'));
    }

    return _webSocketDataSource.connect(
      rideId: params.rideId,
      token: token,
    );
  }

  @override
  Future<Either<AppException, Unit>> sendLocation(
    SendLocationEntity data,
  ) {
    return _webSocketDataSource.sendLocation(data);
  }

  @override
  Future<Either<AppException, Unit>> disconnectFromRide() {
    return _webSocketDataSource.disconnect();
  }

  @override
  Stream<LocationUpdateEntity> listenToLocationUpdates() {
    return _webSocketDataSource.locationStream.map((model) => model.toEntity());
  }
}