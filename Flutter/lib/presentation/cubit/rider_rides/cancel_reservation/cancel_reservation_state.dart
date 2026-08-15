
// حالة نموذج واجهة إلغاء الحجز
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

class CancelReservationCubitState extends Equatable {
  final IdEntity? entity;

  const CancelReservationCubitState({this.entity});

  CancelReservationCubitState copyWith({
    IdEntity? entity,
  }) {
    return CancelReservationCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}