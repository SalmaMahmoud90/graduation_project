// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverInfoModel _$DriverInfoModelFromJson(Map<String, dynamic> json) =>
    DriverInfoModel(
      driverName: json['driver_name'] as String?,
      carImage: json['car_image'] as String?,
    );

RideDataModel _$RideDataModelFromJson(Map<String, dynamic> json) =>
    RideDataModel(
      id: (json['id'] as num?)?.toInt(),
      location: json['location'] as String?,
      destination: json['destination'] as String?,
      departureTime: json['departure_time'] as String?,
      departureDate: json['departure_date'] as String?,
      expectedDuration: json['expected_duration'] as String?,
      cost: json['cost'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      availableSeats: (json['available_seats'] as num?)?.toInt(),
      status: json['status'] as String?,
      carImage: json['car_image'] as String?,
      driverInfo: json['driver_info'] == null
          ? null
          : DriverInfoModel.fromJson(
              json['driver_info'] as Map<String, dynamic>,
            ),
    );

RidesListModel _$RidesListModelFromJson(Map<String, dynamic> json) =>
    RidesListModel(
      rides: (json['rides'] as List<dynamic>?)
          ?.map((e) => RideDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

RideDetailsModel _$RideDetailsModelFromJson(Map<String, dynamic> json) =>
    RideDetailsModel(
      ride: json['ride'] == null
          ? null
          : RideDataModel.fromJson(json['ride'] as Map<String, dynamic>),
    );
