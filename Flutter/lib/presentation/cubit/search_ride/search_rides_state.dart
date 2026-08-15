
import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:equatable/equatable.dart';

class SearchRidesCubitState extends Equatable {
  final SearchRidesEntity? entity;

  const SearchRidesCubitState({this.entity});

  SearchRidesCubitState copyWith({
    SearchRidesEntity? entity,
  }) {
    return SearchRidesCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}