import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../core/helper/local_storage_helper.dart';
import '../../../core/services/locator/locator.dart';

class BaseStorageDataSource {
  final LocalStorageHelper _localHelper = locator<LocalStorageHelper>();
  final String baseBox;

  BaseStorageDataSource(this.baseBox);

  Future<Either<AppException, dynamic>> getAll() async {
    try {
      final response = await _localHelper.getAll(baseBox);
      return response;
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException('Unknown error occurred: ${e.toString()}'));
    }
  }

  Future<Either<AppException, dynamic>> getData({required String key}) async {
    try {
      final response = await _localHelper.getValue(baseBox, key);
      return response;
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException('Unknown error occurred: ${e.toString()}'));
    }
  }

  Future<Either<AppException, dynamic>> saveData({required String key, dynamic data}) async {
    try {
      final response = await _localHelper.saveValue(baseBox, key, data);
      return response;
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException('Unknown error occurred: ${e.toString()}'));
    }
  }

  Future<Either<AppException, bool>> deleteData({required String key}) async {
    try {
      final response = await _localHelper.deleteValue(baseBox, key);
      return response;
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException('Unknown error occurred: ${e.toString()}'));
    }
  }

  Future<Either<AppException, Stream<BoxEvent>?>> listenToData(String key) async {
    try {
      final boxOrError = await _localHelper.openBox(baseBox);
      return boxOrError.fold(
            (error) => Left(error),
            (box) {
          final stream = box.watch(key: key); // Listen to changes for the specific key
          return Right(stream); // Return the stream of box events
        },
      );
    } catch (e) {
      return Left(UnKnownException(e.toString()));
    }
  }


}
