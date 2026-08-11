import 'package:equatable/equatable.dart';

// كيان بدون معاملات — يُستخدم لـ my_rides و my_reservations
class RidesNoParamsEntity extends Equatable {
  const RidesNoParamsEntity();

  @override
  List<Object?> get props => [];
}
