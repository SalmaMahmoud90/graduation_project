
// حالة نموذج واجهة حذف الرحلة
import 'package:a_tareqaak/domain/entity/rides/id_entity.dart';
import 'package:equatable/equatable.dart';

class CancelRideCubitState extends Equatable {
  final IdEntity? entity;

  const CancelRideCubitState({this.entity});

  CancelRideCubitState copyWith({
    IdEntity? entity,
  }) {
    return CancelRideCubitState(
      entity: entity ?? this.entity,
    );
  }

  @override
  List<Object?> get props => [entity];
}