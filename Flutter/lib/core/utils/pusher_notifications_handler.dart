// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:qwafil/core/utils/pusher_service.dart';
//
// class PusherNotificationsHandler {
//   static final PusherNotificationsHandler _instance = PusherNotificationsHandler._internal();
//
//   factory PusherNotificationsHandler() => _instance;
//
//   PusherNotificationsHandler._internal();
//
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   late PusherService _pusherService;
//   bool _isConnected = false;
//
//   // Future<void> init({
//   //   required String channel,
//   //   required List<String> events,
//   //   required Function eventReceived,
//   // }) async {
//   //   // if (!_isConnected) {
//   //   await _initializeNotifications();
//   //   await _setupNotificationChannels();
//   //
//   //   _pusherService = PusherService(
//   //     apiKey: 'a38c05ab87e02b2b8745',
//   //     cluster: 'ap2',
//   //   );
//   //   await _pusherService.initialize(channel: channel, eventReceived: eventReceived);
//   //   _isConnected = true;
//   //   // } else {
//   //   //   // فقط اشترك في القناة الجديدة دون الحاجة لإعادة الاتصال
//   //   //   await _pusherService.subscribe(channel, events, eventReceived);
//   //   // }
//   // }
//
//   Future<void> _initializeNotifications() async {
//     var android = const AndroidInitializationSettings('@mipmap/launcher_icon');
//     var ios = const DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//     var platform = InitializationSettings(android: android, iOS: ios);
//     await _flutterLocalNotificationsPlugin.initialize(
//       platform,
//       onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );
//   }
//
//   Future<void> _setupNotificationChannels() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     await androidImplementation!.createNotificationChannel(
//       const AndroidNotificationChannel(
//         'high_importance_channel',
//         'Dynamic Notifications',
//         description: 'General notifications',
//         importance: Importance.high,
//       ),
//     );
//   }
//
//   static Future<void> showNotification({String? userName, String? avatar, String? chatId, String? message}) async {
//     if (kDebugMode) {
//       print('Foreground notification: $message');
//     }
//     if (message != null) {
//       await _flutterLocalNotificationsPlugin.show(
//         0,
//         userName,
//         message,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'Dynamic Notifications',
//             icon: '@mipmap/launcher_icon',
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: "$avatar^$userName^$chatId",
//       );
//     }
//   }
//
//   Future<void> _onNotificationTap(NotificationResponse? notificationResponse) async {
//     if (notificationResponse != null) {
//       if (kDebugMode) {
//         print('Notification tapped: ${notificationResponse.payload}');
//       }
//       _processMessage(notificationResponse.payload!);
//     }
//   }
//
//   static void _notificationTapBackground(NotificationResponse? notificationResponse) {
//     if (notificationResponse != null) {
//       if (kDebugMode) {
//         print('Notification tapped in background: ${notificationResponse.payload}');
//       }
//       _processMessage(notificationResponse.payload!);
//     }
//   }
//
//   static void _processMessage(String? message) {
//     if (kDebugMode) {
//       print("Processing message: $message");
//     }
//     // List<String> parts = message!.split('^');
//     // String avatar = parts[0];
//     // String userName = parts[1];
//     // String chatId = parts[2];
//     // navigatorKey.currentState?.push(
//     //   MaterialPageRoute(
//     //     builder: (context) {
//     //       return ChatScreen(
//     //         userName: userName,
//     //         avatar: avatar,
//     //         orderID: chatId,
//     //       );
//     //     },
//     //   ),
//     // );
//   }
//
//   void dispose() {
//     _pusherService.disconnect();
//   }
// }
