// lib/presentation/cubit/notifications/notifications_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitialState());

  int currentTab = 0;

  void changeTab(int tabIndex) {
    currentTab = tabIndex;
    emit(NotificationsLoadedState(currentTab));
  }
}