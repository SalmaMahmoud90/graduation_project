
import 'package:equatable/equatable.dart';

sealed class ILogoutEvent extends Equatable {
  const ILogoutEvent();
}

final class LogoutSubmitEvent extends ILogoutEvent {
  const LogoutSubmitEvent();

  @override
  List<Object?> get props => [];
}