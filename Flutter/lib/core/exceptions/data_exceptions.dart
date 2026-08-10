import 'app_exception.dart';

class ServerException extends AppException {
  ServerException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class ConversionException extends AppException {
  ConversionException(String message) : super('ConversionException: $message');
}

