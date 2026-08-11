import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';

abstract interface class IUseCase<T, B> {
  Future<Either<AppException, T>> call(B b);
}