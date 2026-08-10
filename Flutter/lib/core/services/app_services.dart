
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'locator/locator.dart';

class AppServices {

  static void _configureCrashlytics() {

  /* FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;


  PlatformDispatcher.instance.onError =
      (error, stack) {

    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );

    return true;
  }; */
}
  static Future<void> init() async {
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    // await FirebaseNotificationsHandler().init();
    _configureCrashlytics();

    if (!Hive.isAdapterRegistered(0)) {
      await Hive.initFlutter();
    }
    configureDependencies();
  }
}
