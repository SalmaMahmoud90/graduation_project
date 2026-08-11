import 'package:equatable/equatable.dart';

// كيان إنشاء حجز (الراكب)
class CreateReservationEntity extends Equatable {
  final int ride;
  final String pickupLocation;

  const CreateReservationEntity({
    required this.ride,
    required this.pickupLocation,
  });

  Map<String, dynamic> toJson() => {
        "ride": ride,
        "pickup_location": pickupLocation,
      };

  @override
  List<Object?> get props => [ride, pickupLocation];
}
