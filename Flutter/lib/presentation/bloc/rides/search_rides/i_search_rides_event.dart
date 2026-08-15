import 'package:a_tareqaak/domain/entity/rides/search_rides_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ISearchRidesEvent extends Equatable {
  const ISearchRidesEvent();
}

final class SearchRidesEvent extends ISearchRidesEvent {
  final SearchRidesEntity entity;

  const SearchRidesEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}