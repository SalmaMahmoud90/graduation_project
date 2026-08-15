import 'dart:developer';
import 'package:a_tareqaak/data/models/base/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:a_tareqaak/core/exceptions/app_exception.dart';
import 'package:a_tareqaak/core/helper/network_helper.dart';
import 'package:a_tareqaak/core/services/locator/locator.dart';

class BaseRemoteDataSource<T> {
  final NetworkHelper _networkHelper = locator<NetworkHelper>();
  final String baseEndpoint;

  BaseRemoteDataSource(this.baseEndpoint);

  // 👈 إضافة <R> لجعل الدالة مرنة مع أي نموذج إرجاع R
  Future<Either<AppException, BaseModel<R>?>> postData<R>({
    String endpoint = '',
    Map<String, dynamic>? data,
    bool isFormDate = true,
    List<Map<String, dynamic>>? files,
    R Function(Object? json)? fromJsonT,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _networkHelper.post(
        baseEndpoint + endpoint,
        data: data,
        files: files,
        isFormDate: isFormDate,
        requiresAuth: requiresAuth,
      );
      return response.fold(
        (e) => Left(e),
        (r) {
          if (r.data == null) return const Right(null);
          if (fromJsonT == null) {
            return Right(BaseModel<R>(
              message: r.data?['message'] as String?,
              error: r.data?['error'] as String?,
            ));
          }
          // The backend returns flat bodies (no `data` envelope), e.g. forgot
          // password replies with `{message, email, reset_token}` at the top
          // level. Wrap such bodies so the model is parsed from the whole
          // response; already-enveloped responses pass through unchanged.
          final Map<String, dynamic> body = r.data!;
          final Map<String, dynamic> payload =
              body.containsKey('data') ? body : {...body, 'data': body};
          return Right(BaseModel<R>.fromJson(payload, fromJsonT));
        },
      );
    } on AppException catch (e, s) {
      log("############################# POST APP EXCEPTION ################################");
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log("############################# POST EXCEPTION ####################################");
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException(e.toString()));
    }
  }

  // 👈 إضافة <R> لجعل الدالة fetchData مرنة مع أي نموذج R
  Future<Either<AppException, BaseModel<R>?>> fetchData<R>({
    String endpoint = '',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    required R Function(Object? json) fromJsonT,
  }) async {
    try {
      final response = await _networkHelper.get(
        baseEndpoint + endpoint,
        queryParams: queryParams,
        data: data,
      );
      return response.fold(
        (e) => Left(e),
        (r) {
          if (r.data == null) return const Right(null);
          // Wrap flat bodies (no `data` envelope) so fromJsonT receives the
          // whole response — matches the backend which returns flat / named-key
          // bodies (e.g. `{rides: [...]}`, `{ride: {...}}`, `{user: {...}}`).
          final body = r.data!;
          final payload =
              body.containsKey('data') ? body : {...body, 'data': body};
          return Right(BaseModel<R>.fromJson(payload, fromJsonT));
        },
      );
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException(e.toString()));
    }
  }

  // PATCH — used for partial updates (profile, ride update).
  Future<Either<AppException, BaseModel<R>?>> patchData<R>({
    String endpoint = '',
    Map<String, dynamic>? data,
    bool isFormData = true,
    Map<String, dynamic>? queryParams,
    List<Map<String, dynamic>>? files,
    R Function(Object? json)? fromJsonT,
  }) async {
    try {
      final response = await _networkHelper.patch(
        baseEndpoint + endpoint,
        data: data,
        files: files,
        queryParams: queryParams,
        isFormData: isFormData,
      );
      return response.fold(
        (e) => Left(e),
        (r) {
          if (r.data == null) return const Right(null);
          if (fromJsonT == null) {
            return Right(BaseModel<R>(
              message: r.data?['message'] as String?,
              error: r.data?['error'] as String?,
            ));
          }
          final body = r.data!;
          final payload =
              body.containsKey('data') ? body : {...body, 'data': body};
          return Right(BaseModel<R>.fromJson(payload, fromJsonT));
        },
      );
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException(e.toString()));
    }
  }

  // DELETE — used for destructive actions (ride cancel).
  Future<Either<AppException, BaseModel<R>?>> deleteData<R>({
    String endpoint = '',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
    R Function(Object? json)? fromJsonT,
  }) async {
    try {
      final response = await _networkHelper.delete(
        baseEndpoint + endpoint,
        data: data,
        queryParams: queryParams,
      );
      return response.fold(
        (e) => Left(e),
        (r) {
          if (r.data == null) return const Right(null);
          if (fromJsonT == null) {
            return Right(BaseModel<R>(
              message: r.data?['message'] as String?,
              error: r.data?['error'] as String?,
            ));
          }
          final body = r.data!;
          final payload =
              body.containsKey('data') ? body : {...body, 'data': body};
          return Right(BaseModel<R>.fromJson(payload, fromJsonT));
        },
      );
    } on AppException catch (e, s) {
      log(e.message);
      log(s.toString());
      return Left(e);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(UnKnownException(e.toString()));
    }
  }
}