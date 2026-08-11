import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_data_model.g.dart';

// معلومات السائق المضمّنة في نتائج الرحلات
@JsonSerializable(createToJson: false)
class DriverInfoModel extends Equatable {
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @JsonKey(name: 'car_image')
  final String? carImage;

  const DriverInfoModel({this.driverName, this.carImage});

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DriverInfoModelFromJson(json);

  @override
  List<Object?> get props => [driverName, carImage];
}

// نموذج الرحلة القادم من الـ API — يغطي create/update/search/my_rides/details
@JsonSerializable(createToJson: false)
class RideDataModel extends Equatable {
  final int? id;
  final String? location;
  final String? destination;
  @JsonKey(name: 'departure_time')
  final String? departureTime;
  @JsonKey(name: 'departure_date')
  final String? departureDate;
  @JsonKey(name: 'expected_duration')
  final String? expectedDuration;
  final String? cost;
  final int? capacity;
  @JsonKey(name: 'available_seats')
  final int? availableSeats;
  final String? status;
  @JsonKey(name: 'car_image')
  final String? carImage;
  @JsonKey(name: 'driver_info')
  final DriverInfoModel? driverInfo;

  const RideDataModel({
    this.id,
    this.location,
    this.destination,
    this.departureTime,
    this.departureDate,
    this.expectedDuration,
    this.cost,
    this.capacity,
    this.availableSeats,
    this.status,
    this.carImage,
    this.driverInfo,
  });

  factory RideDataModel.fromJson(Map<String, dynamic> json) =>
      _$RideDataModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        location,
        destination,
        departureTime,
        departureDate,
        expectedDuration,
        cost,
        capacity,
        availableSeats,
        status,
        carImage,
        driverInfo,
      ];
}

// غلاف قائمة الرحلات — الاستجابة تأتي بالشكل {"rides": [...]}
@JsonSerializable(createToJson: false)
class RidesListModel extends Equatable {
  final List<RideDataModel>? rides;

  const RidesListModel({this.rides});

  factory RidesListModel.fromJson(Map<String, dynamic> json) =>
      _$RidesListModelFromJson(json);

  @override
  List<Object?> get props => [rides];
}

// غلاف تفاصيل الرحلة — الاستجابة تأتي بالشكل {"ride": {...}}
@JsonSerializable(createToJson: false)
class RideDetailsModel extends Equatable {
  final RideDataModel? ride;

  const RideDetailsModel({this.ride});

  factory RideDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RideDetailsModelFromJson(json);

  @override
  List<Object?> get props => [ride];
}
