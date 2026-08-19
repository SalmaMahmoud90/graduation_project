import 'package:equatable/equatable.dart';

class SendLocationEntity extends Equatable {
  final double latitude;
  final double longitude;

  const SendLocationEntity({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };

  @override
  List<Object?> get props => [latitude, longitude];
}