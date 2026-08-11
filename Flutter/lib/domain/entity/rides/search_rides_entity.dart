import 'package:equatable/equatable.dart';

// كيان البحث عن رحلات
class SearchRidesEntity extends Equatable {
  final String location;
  final String destination;

  const SearchRidesEntity({
    required this.location,
    required this.destination,
  });

  Map<String, dynamic> toQuery() => {
        "location": location,
        "destination": destination,
      };

  @override
  List<Object?> get props => [location, destination];
}
