import 'package:flutter/widgets.dart';

class AppLifecycleTracker with WidgetsBindingObserver {
  AppLifecycleTracker._();

  static final AppLifecycleTracker instance = AppLifecycleTracker._();

  bool _hasAppEnteredForegroundOnce = false;

  bool get hasAppEnteredForegroundOnce => _hasAppEnteredForegroundOnce;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    final currentState = WidgetsBinding.instance.lifecycleState;
    if (currentState == AppLifecycleState.resumed) {
      _hasAppEnteredForegroundOnce = true;
    }
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _hasAppEnteredForegroundOnce = true;
    }
  }
}
