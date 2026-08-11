import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:a_tareqaak/core/constants/app_storage_paths.dart';
import '../../../core/exceptions/app_exception.dart';
import '../base/base_storage_data_source.dart';

@Injectable()
class AuthStorageDataSource extends BaseStorageDataSource {
  AuthStorageDataSource() : super(AppStoragePaths.token);

  Future<Either<AppException, void>> logout() {
    return deleteData(
      key: AppStoragePaths.token,
    );
  }

  Future<Either<AppException, dynamic>> storeToken(String? token) {
    return saveData(
      key: AppStoragePaths.token,
      data: token,
    );
  }

  Future<Either<AppException, String?>> getToken() {
    return getData(
      key: AppStoragePaths.token,
    ).then((e) => e.fold((l) => Left(l), (r) => Right(r as String?)));
  }

  Future<Either<AppException, dynamic>> storeRememberMe(bool rememberMe) {
    return saveData(
      key: AppStoragePaths.rememberMe,
      data: rememberMe,
    );
  }

  Future<Either<AppException, bool>> getRememberMe() {
    return getData(
      key: AppStoragePaths.rememberMe,
    ).then((e) => e.fold((l) => Left(l), (r) => Right(r ?? false)));
  }

  Future<Either<AppException, dynamic>> storeProfileComplete(bool profileComplete) {
    return saveData(
      key: AppStoragePaths.profileComplete,
      data: profileComplete,
    );
  }

  Future<Either<AppException, bool?>> getProfileComplete() {
    return getData(
      key: AppStoragePaths.profileComplete,
    ).then((e) => e.fold((l) => Left(l), (r) => Right(r as bool?)));
  }

  Future<Either<AppException, bool>> deleteProfileComplete() {
    return deleteData(
      key: AppStoragePaths.profileComplete,
    );
  }
}
