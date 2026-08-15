import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class ISearchRidesState extends Equatable {
  const ISearchRidesState();
}

final class SearchRidesInitial extends ISearchRidesState {
  @override
  List<Object> get props => [];
}

final class SearchRidesLoading extends ISearchRidesState {
  @override
  List<Object> get props => [];
}

final class SearchRidesLoaded extends ISearchRidesState {
  final BaseModel<RidesListModel>? response;

  const SearchRidesLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class SearchRidesFailed extends ISearchRidesState {
  final String message;

  const SearchRidesFailed(this.message);

  @override
  List<Object> get props => [message];
}