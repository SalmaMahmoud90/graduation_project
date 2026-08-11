import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchRidesState extends Equatable {
  const SearchRidesState();
  @override
  List<Object?> get props => [];
}

class SearchRidesInitial extends SearchRidesState {}

class SearchRidesLoading extends SearchRidesState {}

class SearchRidesLoaded extends SearchRidesState {
  final List<RideDataModel> rides;
  const SearchRidesLoaded(this.rides);
  @override
  List<Object?> get props => [rides];
}

class SearchRidesError extends SearchRidesState {
  final String message;
  const SearchRidesError(this.message);
  @override
  List<Object?> get props => [message];
}
