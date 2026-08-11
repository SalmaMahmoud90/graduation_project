// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDataModel _$ReservationDataModelFromJson(
  Map<String, dynamic> json,
) => ReservationDataModel(
  id: (json['id'] as num?)?.toInt(),
  ride: (json['ride'] as num?)?.toInt(),
  rider: (json['rider'] as num?)?.toInt(),
  status: json['status'] as String?,
  payment: json['payment'] as String?,
  riderName: json['rider_name'] as String?,
  rideLocation: json['ride_location'] as String?,
  rideDestination: json['ride_destination'] as String?,
  pickupLocation: json['pickup_location'] as String?,
  createdAt: json['created_at'] as String?,
);

ReservationsListModel _$ReservationsListModelFromJson(
  Map<String, dynamic> json,
) => ReservationsListModel(
  reservations: (json['reservations'] as List<dynamic>?)
      ?.map((e) => ReservationDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);
