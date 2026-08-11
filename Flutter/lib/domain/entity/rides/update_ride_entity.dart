import 'package:equatable/equatable.dart';

// كيان تحديث رحلة (تحديث جزئي) — id في المسار وليس في الجسم
class UpdateRideEntity extends Equatable {
  final int id;
  final String? location;
  final String? destination;
  final String? departureTime;
  final String? departureDate;
  final String? expectedDuration;
  final String? cost;
  final int? capacity;

  const UpdateRideEntity({
    required this.id,
    this.location,
    this.destination,
    this.departureTime,
    this.departureDate,
    this.expectedDuration,
    this.cost,
    this.capacity,
  });

  Map<String, dynamic> toJson() => {
        if (location != null) "location": location,
        if (destination != null) "destination": destination,
        if (departureTime != null) "departure_time": departureTime,
        if (departureDate != null) "departure_date": departureDate,
        if (expectedDuration != null) "expected_duration": expectedDuration,
        if (cost != null) "cost": cost,
        if (capacity != null) "capacity": capacity,
      };

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
      ];
}
