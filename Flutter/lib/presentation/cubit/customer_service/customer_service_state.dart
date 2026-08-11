
import 'package:flutter/foundation.dart';

@immutable
abstract class CustomerServiceState {}

class CustomerServiceInitialState extends CustomerServiceState {}

class CustomerServiceLoadingState extends CustomerServiceState {}

class CustomerServiceSuccessState extends CustomerServiceState {}

class CustomerServiceErrorState extends CustomerServiceState {
  final String message;
  CustomerServiceErrorState(this.message);
}