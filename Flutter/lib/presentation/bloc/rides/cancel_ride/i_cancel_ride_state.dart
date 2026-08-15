import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:equatable/equatable.dart';

sealed class ICancelRideState extends Equatable {
  const ICancelRideState();
}

final class CancelRideInitial extends ICancelRideState {
  @override
  List<Object> get props => [];
}

final class CancelRideLoading extends ICancelRideState {
  @override
  List<Object> get props => [];
}

final class CancelRideLoaded extends ICancelRideState {
  final BaseModel<dynamic>? response;

  const CancelRideLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class CancelRideFailed extends ICancelRideState {
  final String message;

  const CancelRideFailed(this.message);

  @override
  List<Object> get props => [message];
}