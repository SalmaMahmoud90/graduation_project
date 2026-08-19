// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dartz/dartz.dart' as _i590;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../data/data_source/auth/auth_remote_data_source.dart' as _i319;
import '../../../data/data_source/auth/auth_storage_data_source.dart' as _i300;
import '../../../data/data_source/location/location_websocket_data_source.dart'
    as _i255;
import '../../../data/data_source/payment/payment_remote_data_source.dart'
    as _i716;
import '../../../data/data_source/profile/profile_remote_data_source.dart'
    as _i1017;
import '../../../data/data_source/report/report_remote_data_source.dart'
    as _i705;
import '../../../data/data_source/rides/rides_remote_data_source.dart' as _i972;
import '../../../data/models/auth/forgot_password_response/forgot_password_response_model.dart'
    as _i402;
import '../../../data/models/auth/token/tokens_model.dart' as _i9;
import '../../../data/models/auth/user/user_model.dart' as _i1011;
import '../../../data/models/base/base_model.dart' as _i480;
import '../../../data/models/payment/payment_models.dart' as _i434;
import '../../../data/models/profile/profile_model.dart' as _i705;
import '../../../data/models/report/report_data_model.dart' as _i359;
import '../../../data/models/rides/reservation_data_model.dart' as _i156;
import '../../../data/models/rides/ride_data_model.dart' as _i277;
import '../../../data/repository/auth/auth_repository.dart' as _i728;
import '../../../data/repository/location/ride_track_repository.dart' as _i502;
import '../../../data/repository/payment/payment_repository.dart' as _i1032;
import '../../../data/repository/profile/profile_repository.dart' as _i732;
import '../../../data/repository/report/report_repository.dart' as _i1034;
import '../../../data/repository/rides/rides_repository.dart' as _i459;
import '../../../domain/entity/auth/forgot_password/forgot_password_entity.dart'
    as _i146;
import '../../../domain/entity/auth/login/login_entity.dart' as _i27;
import '../../../domain/entity/auth/logout/logout_entity.dart' as _i385;
import '../../../domain/entity/auth/register/register_entity.dart' as _i811;
import '../../../domain/entity/auth/resend_reset_code/resend_reset_code.dart'
    as _i1008;
import '../../../domain/entity/auth/resend_verification/resend_verification_entity.dart'
    as _i1012;
import '../../../domain/entity/auth/reset_password/reset_password_entity.dart'
    as _i854;
import '../../../domain/entity/auth/verify_email/verify_email_entity.dart'
    as _i592;
import '../../../domain/entity/auth/verify_reset_code/verify_reset_code_entity.dart'
    as _i31;
import '../../../domain/entity/location/ride_tracking_connection_entity.dart'
    as _i78;
import '../../../domain/entity/location/send_location_entity.dart' as _i115;
import '../../../domain/entity/payment/payment_entity.dart' as _i177;
import '../../../domain/entity/profile/update_driver_profile_entity.dart'
    as _i307;
import '../../../domain/entity/profile/update_rider_profile_entity.dart'
    as _i739;
import '../../../domain/entity/profile/view_profile_entity.dart' as _i937;
import '../../../domain/entity/report/report_entity.dart' as _i78;
import '../../../domain/entity/rides/create_reservation_entity.dart' as _i88;
import '../../../domain/entity/rides/create_ride_entity.dart' as _i361;
import '../../../domain/entity/rides/id_entity.dart' as _i674;
import '../../../domain/entity/rides/rides_no_params_entity.dart' as _i110;
import '../../../domain/entity/rides/search_rides_entity.dart' as _i40;
import '../../../domain/entity/rides/update_ride_entity.dart' as _i1021;
import '../../../domain/repository/auth/i_auth_repository.dart' as _i154;
import '../../../domain/repository/location/i_ride_tracking_repository.dart'
    as _i257;
import '../../../domain/repository/payment/_payment_repository.dart' as _i660;
import '../../../domain/repository/profile/i_profile_repository.dart' as _i950;
import '../../../domain/repository/report/i_report_repository.dart' as _i58;
import '../../../domain/repository/rides/i_rides_repository.dart' as _i879;
import '../../../domain/usecase/auth/forgot_password/forgot_password_usecase.dart'
    as _i854;
import '../../../domain/usecase/auth/login/login_usecase.dart' as _i710;
import '../../../domain/usecase/auth/logout/logout_usecase.dart' as _i638;
import '../../../domain/usecase/auth/register/register_usecase.dart' as _i523;
import '../../../domain/usecase/auth/resend_reset_code/resend_reset_code_usecase.dart'
    as _i707;
import '../../../domain/usecase/auth/resend_verification/resend_verification_usecase.dart'
    as _i1040;
import '../../../domain/usecase/auth/reset_password/reset_password_usecase.dart'
    as _i844;
import '../../../domain/usecase/auth/verify_email/verify_email_usecase.dart'
    as _i912;
import '../../../domain/usecase/auth/verify_reset_code/verify_reset_code_usecase.dart'
    as _i873;
import '../../../domain/usecase/i_use_case.dart' as _i759;
import '../../../domain/usecase/location/connect_to_ride_tracking_usecase.dart'
    as _i722;
import '../../../domain/usecase/location/disconnect_from_ride_tracking_usecase.dart'
    as _i132;
import '../../../domain/usecase/location/listen_to_location_update_usecase.dart'
    as _i33;
import '../../../domain/usecase/location/send_location_usecase.dart' as _i568;
import '../../../domain/usecase/payment/create_deposit_request_usecase.dart'
    as _i603;
import '../../../domain/usecase/payment/get_deposit_requests_usecase.dart'
    as _i986;
import '../../../domain/usecase/payment/get_transactions_usecase.dart' as _i569;
import '../../../domain/usecase/payment/get_wallet_balance_usecase.dart'
    as _i853;
import '../../../domain/usecase/payment/pay_reservation_usecase.dart' as _i511;
import '../../../domain/usecase/profile/update_driver_profile_usecase.dart'
    as _i622;
import '../../../domain/usecase/profile/update_rider_profile_usecase.dart'
    as _i589;
import '../../../domain/usecase/profile/view_profile_usecase.dart' as _i688;
import '../../../domain/usecase/report/create_report_usecase.dart' as _i577;
import '../../../domain/usecase/report/get_my_reports_usecase.dart' as _i873;
import '../../../domain/usecase/report/get_report_details_usecase.dart'
    as _i379;
import '../../../domain/usecase/rides/accept_reservation_usecase.dart'
    as _i1040;
import '../../../domain/usecase/rides/cancel_reservation_usecase.dart'
    as _i1035;
import '../../../domain/usecase/rides/cancel_ride_usecase.dart' as _i790;
import '../../../domain/usecase/rides/create_reservation_usecase.dart' as _i612;
import '../../../domain/usecase/rides/create_ride_usecase.dart' as _i1068;
import '../../../domain/usecase/rides/my_reservations_usecase.dart' as _i735;
import '../../../domain/usecase/rides/my_rides_usecase.dart' as _i25;
import '../../../domain/usecase/rides/reject_reservation_usecase.dart' as _i437;
import '../../../domain/usecase/rides/ride_details_usecase.dart' as _i122;
import '../../../domain/usecase/rides/search_rides_usecase.dart' as _i505;
import '../../../domain/usecase/rides/update_ride_usecase.dart' as _i878;
import '../../helper/local_storage_helper.dart' as _i218;
import '../../helper/network_helper.dart' as _i779;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i779.NetworkHelper>(() => _i779.NetworkHelper());
    gh.factory<_i319.AuthRemoteDataSource>(() => _i319.AuthRemoteDataSource());
    gh.factory<_i300.AuthStorageDataSource>(
      () => _i300.AuthStorageDataSource(),
    );
    gh.factory<_i255.LocationWebSocketDataSource>(
      () => _i255.LocationWebSocketDataSource(),
    );
    gh.factory<_i716.PaymentRemoteDataSource>(
      () => _i716.PaymentRemoteDataSource(),
    );
    gh.factory<_i1017.ProfileRemoteDataSource>(
      () => _i1017.ProfileRemoteDataSource(),
    );
    gh.factory<_i705.ReportRemoteDataSource>(
      () => _i705.ReportRemoteDataSource(),
    );
    gh.factory<_i972.RidesRemoteDataSource>(
      () => _i972.RidesRemoteDataSource(),
    );
    gh.lazySingleton<_i218.LocalStorageHelper>(
      () => _i218.LocalStorageHelper(),
    );
    gh.factory<_i58.IReportRepository>(
      () => _i1034.ReportRepository(gh<_i705.ReportRemoteDataSource>()),
    );
    gh.factory<_i660.IPaymentRepository>(
      () => _i1032.PaymentRepository(gh<_i716.PaymentRemoteDataSource>()),
    );
    gh.factory<_i950.IProfileRepository>(
      () => _i732.ProfileRepository(gh<_i1017.ProfileRemoteDataSource>()),
    );
    gh.factory<_i257.IRideTrackingRepository>(
      () => _i502.RideTrackingRepository(
        gh<_i255.LocationWebSocketDataSource>(),
        gh<_i218.LocalStorageHelper>(),
      ),
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<dynamic>?, _i307.UpdateDriverProfileEntity>
    >(
      () => _i622.UpdateDriverProfileUseCase(gh<_i950.IProfileRepository>()),
      instanceName: 'UpdateDriverProfileUseCase',
    );
    gh.factory<_i759.IUseCase<_i590.Unit, _i78.RideTrackingConnectionEntity>>(
      () => _i722.ConnectToRideTrackingUseCase(
        gh<_i257.IRideTrackingRepository>(),
      ),
      instanceName: 'ConnectToRideTrackingUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<dynamic>?, _i739.UpdateRiderProfileEntity>
    >(
      () => _i589.UpdateRiderProfileUseCase(gh<_i950.IProfileRepository>()),
      instanceName: 'UpdateRiderProfileUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i434.TransactionsListModel>?,
        _i110.RidesNoParamsEntity
      >
    >(
      () => _i569.GetTransactionsUseCase(gh<_i660.IPaymentRepository>()),
      instanceName: 'GetTransactionsUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i359.ReportDataModel>?, _i674.IdEntity>
    >(
      () => _i379.GetReportDetailsUseCase(gh<_i58.IReportRepository>()),
      instanceName: 'GetReportDetailsUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i434.DepositRequestDataModel>?,
        _i177.CreateDepositRequestEntity
      >
    >(
      () => _i603.CreateDepositRequestUseCase(gh<_i660.IPaymentRepository>()),
      instanceName: 'CreateDepositRequestUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i359.ReportsListModel>?,
        _i110.RidesNoParamsEntity
      >
    >(
      () => _i873.GetMyReportsUseCase(gh<_i58.IReportRepository>()),
      instanceName: 'GetMyReportsUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i359.ReportDataModel>?,
        _i78.CreateReportEntity
      >
    >(
      () => _i577.CreateReportUseCase(gh<_i58.IReportRepository>()),
      instanceName: 'CreateReportUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i434.PayResponseModel>?,
        _i177.PayReservationEntity
      >
    >(
      () => _i511.PayReservationUseCase(gh<_i660.IPaymentRepository>()),
      instanceName: 'PayReservationUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i434.DepositRequestsListModel>?,
        _i110.RidesNoParamsEntity
      >
    >(
      () => _i986.GetDepositRequestsUseCase(gh<_i660.IPaymentRepository>()),
      instanceName: 'GetDepositRequestsUseCase',
    );
    gh.factory<_i879.IRidesRepository>(
      () => _i459.RidesRepository(gh<_i972.RidesRemoteDataSource>()),
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i434.WalletBalanceModel>?,
        _i110.RidesNoParamsEntity
      >
    >(
      () => _i853.GetWalletBalanceUseCase(gh<_i660.IPaymentRepository>()),
      instanceName: 'GetWalletBalanceUseCase',
    );
    gh.factory<_i154.IAuthRepository>(
      () => _i728.AuthRepository(gh<_i319.AuthRemoteDataSource>()),
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i1012.ResendVerificationEntity
      >
    >(
      () => _i1040.ResendVerificationUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ResendVerificationUseCase',
    );
    gh.factory<_i759.IUseCase<_i590.Unit, _i759.NoParams>>(
      () => _i132.DisconnectFromRideTrackingUseCase(
        gh<_i257.IRideTrackingRepository>(),
      ),
      instanceName: 'DisconnectFromRideTrackingUseCase',
    );
    gh.factory<_i759.IUseCase<_i480.BaseModel<dynamic>?, _i674.IdEntity>>(
      () => _i1035.CancelReservationUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'CancelReservationUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i277.RideDataModel>?,
        _i1021.UpdateRideEntity
      >
    >(
      () => _i878.UpdateRideUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'UpdateRideUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i705.ProfileModel>?,
        _i937.ViewProfileEntity
      >
    >(
      () => _i688.ViewProfileUseCase(gh<_i950.IProfileRepository>()),
      instanceName: 'ViewProfileUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i277.RidesListModel>?,
        _i40.SearchRidesEntity
      >
    >(
      () => _i505.SearchRidesUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'SearchRidesUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i156.ReservationsListModel>?,
        _i110.RidesNoParamsEntity
      >
    >(
      () => _i735.MyReservationsUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'MyReservationsUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i156.ReservationDataModel>?,
        _i88.CreateReservationEntity
      >
    >(
      () => _i612.CreateReservationUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'CreateReservationUseCase',
    );
    gh.factory<_i759.IUseCase<_i590.Unit, _i115.SendLocationEntity>>(
      () => _i568.SendLocationUseCase(gh<_i257.IRideTrackingRepository>()),
      instanceName: 'SendLocationUseCase',
    );
    gh.factory<_i759.IUseCase<_i480.BaseModel<dynamic>?, _i674.IdEntity>>(
      () => _i437.RejectReservationUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'RejectReservationUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i277.RideDetailsModel>?, _i674.IdEntity>
    >(
      () => _i122.RideDetailsUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'RideDetailsUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i277.RideDataModel>?,
        _i361.CreateRideEntity
      >
    >(
      () => _i1068.CreateRideUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'CreateRideUseCase',
    );
    gh.factory<_i33.ListenToLocationUpdatesUseCase>(
      () => _i33.ListenToLocationUpdatesUseCase(
        gh<_i257.IRideTrackingRepository>(),
      ),
    );
    gh.factory<_i759.IUseCase<_i480.BaseModel<dynamic>?, _i674.IdEntity>>(
      () => _i790.CancelRideUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'CancelRideUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i277.RidesListModel>?,
        _i110.RidesNoParamsEntity
      >
    >(
      () => _i25.MyRidesUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'MyRidesUseCase',
    );
    gh.factory<_i759.IUseCase<_i480.BaseModel<dynamic>?, _i674.IdEntity>>(
      () => _i1040.AcceptReservationUseCase(gh<_i879.IRidesRepository>()),
      instanceName: 'AcceptReservationUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i9.TokensModel>?, _i27.LoginEntity>
    >(
      () => _i710.LoginUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'LoginUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i854.ResetPasswordEntity
      >
    >(
      () => _i844.ResetPasswordUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ResetPasswordUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i402.ForgotPasswordResponseModel>?,
        _i146.ForgotPasswordEntity
      >
    >(
      () => _i854.ForgotPasswordUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ForgotPasswordUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i1011.UserModel>?, _i811.RegisterEntity>
    >(
      () => _i523.RegisterUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'RegisterUseCase',
    );
    gh.factory<
      _i759.IUseCase<_i480.BaseModel<_i1011.UserModel>?, _i385.LogoutEntity>
    >(
      () => _i638.LogoutUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'LogoutUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i592.VerifyEmailEntity
      >
    >(
      () => _i912.VerifyEmailUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'VerifyEmailUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i31.VerifyResetCodeEntity
      >
    >(
      () => _i873.VerifyResetCodeUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'VerifyResetCodeUseCase',
    );
    gh.factory<
      _i759.IUseCase<
        _i480.BaseModel<_i1011.UserModel>?,
        _i1008.ResendResetCodeEntity
      >
    >(
      () => _i707.ResendResetCodeUseCase(gh<_i154.IAuthRepository>()),
      instanceName: 'ResendResetCodeUseCase',
    );
    return this;
  }
}
