// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/foundation.dart';
// import 'package:qwafil/core/constants/api_endpoints.dart';
// import 'package:qwafil/core/services/locator/locator.dart';
// import 'package:http/http.dart' as http;
// import 'package:qwafil/data/data_source/auth/auth_storage_data_source.dart';
// import 'package:qwafil/data/model/receive_message/receive_message_model.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//
// class PusherService {
//   final PusherChannelsFlutter _pusher;
//   final String apiKey;
//   late String channel;
//
//   // final String authEndpoint;
//   final String cluster;
//
//   PusherService({
//     required this.apiKey,
//     // required this.authEndpoint,
//     required this.cluster,
//   }) : _pusher = PusherChannelsFlutter.getInstance();
//
//   Future<void> initialize({
//     required String channel,
//     required Function eventReceived,
//     required bool isOwner,
//   }) async {
//     try {
//       await _pusher.init(
//         onConnectionStateChange: onConnectionStateChange,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onDecryptionFailure: onDecryptionFailure,
//         onSubscriptionError: onSubscriptionError,
//         onMemberRemoved: onMemberRemoved,
//         onMemberAdded: onMemberAdded,
//         onAuthorizer: onAuthorizer,
//         onError: onError,
//         onEvent: onEvent,
//         apiKey: apiKey,
//         // authEndpoint: authEndpoint,
//         cluster: cluster,
//       );
//       await subscribe(channel, eventReceived, isOwner);
//       await _pusher.connect();
//       this.channel = channel;
//     } catch (e, s) {
//       log("ERROR: $e");
//       log("STACK: $s");
//     }
//   }
//
//   Future<void> subscribe(String channel, Function eventReceived, bool isOwner) async {
//     await _pusher.subscribe(
//         channelName: channel,
//         onEvent: (event) {
//           try {
//             int count = 1;
//             if (event.eventName == "pusher:subscription_succeeded") {
//               count = event.data['presence']?['count'];
//             }
//             if (event.eventName == r"App\Events\Chat\MessageSent") {
//               final messageData = ReceiveMessageModel.fromJson(jsonDecode(event.data));
//               print('!!!!!!!!');
//               print(messageData.message!.typeUser);
//               print(isOwner);
//               print('!!!!!!!!');
//               if ((messageData.message!.typeUser == "owner" && !isOwner) || (messageData.message!.typeUser == "user" && isOwner)) {
//                 print('11111111111');
//                 eventReceived(event);
//               }
//             }
//             if (event.eventName == "pusher_internal:member_added" ||
//                 event.eventName == "pusher_internal:member_removed") {
//               eventReceived(event);
//             }
//             if (count == 2) {
//               eventReceived(event);
//             }
//           } catch (e, stackTrace) {
//             log("Error in onEvent: $e");
//             log("StackTrace: $stackTrace");
//           }
//         });
//   }
//
//   dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
//     String? token =
//         await locator<AuthStorageDataSource>().getToken().then((result) => result.fold((l) => null, (r) => r));
//     var authUrl = "http://${ApiEndpoints.host}:8000/broadcasting/auth";
//     var result = await http.post(
//       Uri.parse(authUrl),
//       headers: {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         'Authorization': 'Bearer $token',
//       },
//       body: 'socket_id=$socketId&channel_name=$channelName',
//     );
//     var json = jsonDecode(result.body);
//     return json;
//   }
//
//   void onEvent(PusherEvent event) {
//     try {
//       if (kDebugMode) {
//         print("onEvent: $event");
//       }
//       log("LOCAL EVENT NAME: $event");
//       log("REMOTE EVENT NAME: ${event.eventName}");
//       log("Event Data: ${event.data}");
//     } catch (e, stackTrace) {
//       log("Error in onEvent: $e");
//       log("StackTrace: $stackTrace");
//     }
//   }
//
//   void onError(String message, int? code, dynamic e) {
//     if (kDebugMode) {
//       print("onError: $message code: $code exception: $e");
//     }
//   }
//
//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     if (kDebugMode) {
//       print("Connection: $currentState");
//     }
//   }
//
//   void onMemberRemoved(String channelName, PusherMember member) {
//     if (kDebugMode) {
//       print("onMemberRemoved: $channelName member: $member");
//     }
//   }
//
//   void onMemberAdded(String channelName, PusherMember member) {
//     if (kDebugMode) {
//       print("onMemberAdded: $channelName member: $member");
//     }
//   }
//
//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     if (kDebugMode) {
//       print("onSubscriptionSucceeded: $channelName data: $data");
//     }
//   }
//
//   void onSubscriptionError(String message, dynamic e) {
//     if (kDebugMode) {
//       print("onSubscriptionError: $message Exception: $e");
//     }
//   }
//
//   void onDecryptionFailure(String event, String reason) {
//     if (kDebugMode) {
//       print("onDecryptionFailure: $event reason: $reason");
//     }
//   }
//
//   void disconnect() {
//     _pusher.disconnect();
//     _pusher.unsubscribe(channelName: channel);
//   }
// }
