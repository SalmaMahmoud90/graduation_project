import 'package:flutter/foundation.dart';

@immutable
abstract class PublishRideState {}

class PublishRideInitialState extends PublishRideState {}

class PublishRideFieldsUpdatedState extends PublishRideState {}

class PublishRideLoadingState extends PublishRideState {}

class PublishRideSuccessState extends PublishRideState {}

class PublishRideErrorState extends PublishRideState {
  final String message;

  PublishRideErrorState(this.message);
}