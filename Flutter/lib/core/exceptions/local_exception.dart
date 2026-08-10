import 'app_exception.dart';

class BoxOpenException extends AppException {
  BoxOpenException(super.message);
}

class StoreValueException extends BoxOpenException {
  StoreValueException(super.message);
}

class DeleteValueException extends BoxOpenException {
  DeleteValueException(super.message);
}

class NotFoundValueException extends BoxOpenException {
  NotFoundValueException(super.message);
}

class ClearBoxException extends BoxOpenException {
  ClearBoxException(super.message);
}

class GetValueException extends BoxOpenException {
  GetValueException(super.message);
}