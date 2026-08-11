

import 'package:a_tareqaak/domain/entity/auth/register/register_entity.dart';
import 'package:equatable/equatable.dart';


sealed class IRegisterEvent extends Equatable {
  const IRegisterEvent();
}

final class RegisterEvent extends IRegisterEvent {
  final RegisterEntity entity;

  const RegisterEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}