import 'package:equatable/equatable.dart';

// كيان إنشاء رحلة (السائق)
class CreateRideEntity extends Equatable {
  final String location;
  final String destination;
  final String departureTime; // HH:MM or HH:MM:SS
  final String departureDate; // YYYY-MM-DD
  final String? expectedDuration;
  final String cost; // decimal as string
  final int capacity;

  const CreateRideEntity({
    required this.location,
    required this.destination,
    required this.departureTime,
    required this.departureDate,
    this.expectedDuration,
    required this.cost,
    required this.capacity,
  });

  Map<String, dynamic> toJson() => {
        "location": location,
        "destination": destination,
        "departure_time": departureTime,
        "departure_date": departureDate,
        if (expectedDuration != null) "expected_duration": expectedDuration,
        "cost": cost,
        "capacity": capacity,
      };

  @override
  List<Object?> get props => [
        location,
        destination,
        departureTime,
        departureDate,
        expectedDuration,
        cost,
        capacity,
      ];
}
