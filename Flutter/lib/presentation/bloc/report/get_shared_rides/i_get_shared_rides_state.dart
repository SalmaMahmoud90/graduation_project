
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:a_tareqaak/data/models/rides/ride_data_model.dart';
import 'package:equatable/equatable.dart';

sealed class IGetSharedRidesState extends Equatable {
  const IGetSharedRidesState();
}

final class GetSharedRidesInitial extends IGetSharedRidesState {
  @override
  List<Object> get props => [];
}

final class GetSharedRidesLoading extends IGetSharedRidesState {
  @override
  List<Object> get props => [];
}

final class GetSharedRidesLoaded extends IGetSharedRidesState {
  final BaseModel<RidesListModel>? responseModel;

  const GetSharedRidesLoaded({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

final class GetSharedRidesFailed extends IGetSharedRidesState {
  final String message;

  const GetSharedRidesFailed(this.message);

  @override
  List<Object> get props => [message];
}