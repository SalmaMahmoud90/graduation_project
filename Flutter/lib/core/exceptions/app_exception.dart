import 'dart:developer';

class AppException implements Exception {
  final String message;
  final String? lang;

  AppException(this.message,[this.lang]) {
    log("AppException: $message");
  }

  @override
  String toString() => 'AppException: $message';
}

class UnKnownException extends AppException {
  UnKnownException(String message) : super('Unknown error: $message');
}

