import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_data_model.g.dart';

// نموذج الحجز القادم من الـ API — يغطي create و my_reservations
@JsonSerializable(createToJson: false)
class ReservationDataModel extends Equatable {
  final int? id;
  final int? ride;
  final int? rider;
  final String? status;
  final String? payment;
  @JsonKey(name: 'rider_name')
  final String? riderName;
  @JsonKey(name: 'ride_location')
  final String? rideLocation;
  @JsonKey(name: 'ride_destination')
  final String? rideDestination;
  @JsonKey(name: 'pickup_location')
  final String? pickupLocation;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const ReservationDataModel({
    this.id,
    this.ride,
    this.rider,
    this.status,
    this.payment,
    this.riderName,
    this.rideLocation,
    this.rideDestination,
    this.pickupLocation,
    this.createdAt,
  });

  factory ReservationDataModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationDataModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        ride,
        rider,
        status,
        payment,
        riderName,
        rideLocation,
        rideDestination,
        pickupLocation,
        createdAt,
      ];
}

// غلاف قائمة الحجوزات — الاستجابة تأتي بالشكل {"reservations": [...]}
@JsonSerializable(createToJson: false)
class ReservationsListModel extends Equatable {
  final List<ReservationDataModel>? reservations;

  const ReservationsListModel({this.reservations});

  factory ReservationsListModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationsListModelFromJson(json);

  @override
  List<Object?> get props => [reservations];
}
