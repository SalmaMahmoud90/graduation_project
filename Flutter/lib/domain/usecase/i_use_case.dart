import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:equatable/equatable.dart';

abstract interface class IUseCase<T, B> {
  Future<Either<AppException, T>> call(B b);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}