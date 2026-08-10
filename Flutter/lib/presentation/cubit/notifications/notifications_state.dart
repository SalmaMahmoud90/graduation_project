// lib/presentation/cubit/notifications/notifications_state.dart
import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitialState extends NotificationsState {}

class NotificationsLoadedState extends NotificationsState {
  final int selectedTab; // 0: الكل، 1: غير المقروءة
  NotificationsLoadedState(this.selectedTab);
}