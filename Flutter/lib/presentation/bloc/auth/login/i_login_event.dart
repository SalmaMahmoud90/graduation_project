
import 'package:a_tareqaak/domain/entity/auth/login/login_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ILoginEvent extends Equatable {
  const ILoginEvent();
}

// 👈 اسم الحدث المعتمد المطابق لمشروع قوافل LoginEvent
final class LoginEvent extends ILoginEvent {
  final LoginEntity entity;

  const LoginEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}