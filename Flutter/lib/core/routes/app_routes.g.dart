// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashRoute,
  $loginRoute,
  $registerRoute,
  $checkCodeRoute,
  $editRideRoute,
  $publishRideRoute,
  $selectCityRoute,
  $editRideListRoute,
  $deleteRideRoute,
  $rideDetailsRoute,
  $customerServiceRoute,
  $driverProfileRoute,
  $editDriverProfileRoute,
  $driverShellRoute,
  $sendReportRoute,
  $myReportsRoute,
  $reportDetailsRoute,
  $resetPasswordRoute,
  $forgotPasswordRoute,
  $riderShellRoute,
  $walletRoute,
  $chargeWalletRoute,
  $transactionHistoryRoute,
  $depositRequestsRoute,
  $searchRideFormRoute,
  $searchResultsRoute,
  $driverReservationsRoute,
];

RouteBase get $splashRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $SplashRoute._fromState,
);

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) => SplashRoute(
    annualAuctionId: state.uri.queryParameters['annual-auction-id'],
  );

  SplashRoute get _self => this as SplashRoute;

  @override
  String get location => GoRouteData.$location(
    '/',
    queryParams: {
      if (_self.annualAuctionId != null)
        'annual-auction-id': _self.annualAuctionId,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRoute._fromState,
);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => RegisterRoute();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $checkCodeRoute => GoRouteData.$route(
  path: '/check-code',
  hasOverriddenOnExit: false,
  factory: $CheckCodeRoute._fromState,
);

mixin $CheckCodeRoute on GoRouteData {
  static CheckCodeRoute _fromState(GoRouterState state) => CheckCodeRoute(
    email: state.uri.queryParameters['email']!,
    isForgotPassword:
        _$convertMapValue(
          'is-forgot-password',
          state.uri.queryParameters,
          _$boolConverter,
        ) ??
        false,
    resetToken: state.uri.queryParameters['reset-token'],
  );

  CheckCodeRoute get _self => this as CheckCodeRoute;

  @override
  String get location => GoRouteData.$location(
    '/check-code',
    queryParams: {
      'email': _self.email,
      if (_self.isForgotPassword != false)
        'is-forgot-password': _self.isForgotPassword.toString(),
      if (_self.resetToken != null) 'reset-token': _self.resetToken,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $editRideRoute => GoRouteData.$route(
  path: '/edit-ride',
  hasOverriddenOnExit: false,
  factory: $EditRideRoute._fromState,
);

mixin $EditRideRoute on GoRouteData {
  static EditRideRoute _fromState(GoRouterState state) =>
      EditRideRoute($extra: state.extra as RideDataModel);

  EditRideRoute get _self => this as EditRideRoute;

  @override
  String get location => GoRouteData.$location('/edit-ride');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $publishRideRoute => GoRouteData.$route(
  path: '/publish-ride',
  hasOverriddenOnExit: false,
  factory: $PublishRideRoute._fromState,
);

mixin $PublishRideRoute on GoRouteData {
  static PublishRideRoute _fromState(GoRouterState state) => PublishRideRoute();

  @override
  String get location => GoRouteData.$location('/publish-ride');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $selectCityRoute => GoRouteData.$route(
  path: '/select-city',
  hasOverriddenOnExit: false,
  factory: $SelectCityRoute._fromState,
);

mixin $SelectCityRoute on GoRouteData {
  static SelectCityRoute _fromState(GoRouterState state) => SelectCityRoute();

  @override
  String get location => GoRouteData.$location('/select-city');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editRideListRoute => GoRouteData.$route(
  path: '/edit-ride-list',
  hasOverriddenOnExit: false,
  factory: $EditRideListRoute._fromState,
);

mixin $EditRideListRoute on GoRouteData {
  static EditRideListRoute _fromState(GoRouterState state) =>
      EditRideListRoute();

  @override
  String get location => GoRouteData.$location('/edit-ride-list');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $deleteRideRoute => GoRouteData.$route(
  path: '/delete-ride',
  hasOverriddenOnExit: false,
  factory: $DeleteRideRoute._fromState,
);

mixin $DeleteRideRoute on GoRouteData {
  static DeleteRideRoute _fromState(GoRouterState state) => DeleteRideRoute();

  @override
  String get location => GoRouteData.$location('/delete-ride');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $rideDetailsRoute => GoRouteData.$route(
  path: '/ride-details',
  hasOverriddenOnExit: false,
  factory: $RideDetailsRoute._fromState,
);

mixin $RideDetailsRoute on GoRouteData {
  static RideDetailsRoute _fromState(GoRouterState state) =>
      RideDetailsRoute($extra: state.extra as RideDataModel);

  RideDetailsRoute get _self => this as RideDetailsRoute;

  @override
  String get location => GoRouteData.$location('/ride-details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $customerServiceRoute => GoRouteData.$route(
  path: '/customer-service',
  hasOverriddenOnExit: false,
  factory: $CustomerServiceRoute._fromState,
);

mixin $CustomerServiceRoute on GoRouteData {
  static CustomerServiceRoute _fromState(GoRouterState state) =>
      CustomerServiceRoute();

  @override
  String get location => GoRouteData.$location('/customer-service');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $driverProfileRoute => GoRouteData.$route(
  path: '/driver-profile',
  hasOverriddenOnExit: false,
  factory: $DriverProfileRoute._fromState,
);

mixin $DriverProfileRoute on GoRouteData {
  static DriverProfileRoute _fromState(GoRouterState state) =>
      DriverProfileRoute(
        isOtherUser: _$convertMapValue(
          'is-other-user',
          state.uri.queryParameters,
          _$boolConverter,
        ),
        otherUserId: _$convertMapValue(
          'other-user-id',
          state.uri.queryParameters,
          int.tryParse,
        ),
      );

  DriverProfileRoute get _self => this as DriverProfileRoute;

  @override
  String get location => GoRouteData.$location(
    '/driver-profile',
    queryParams: {
      if (_self.isOtherUser != null)
        'is-other-user': _self.isOtherUser!.toString(),
      if (_self.otherUserId != null)
        'other-user-id': _self.otherUserId!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editDriverProfileRoute => GoRouteData.$route(
  path: '/edit-driver-profile',
  hasOverriddenOnExit: false,
  factory: $EditDriverProfileRoute._fromState,
);

mixin $EditDriverProfileRoute on GoRouteData {
  static EditDriverProfileRoute _fromState(GoRouterState state) =>
      EditDriverProfileRoute(
        isMandatory: _$convertMapValue(
          'is-mandatory',
          state.uri.queryParameters,
          _$boolConverter,
        ),
      );

  EditDriverProfileRoute get _self => this as EditDriverProfileRoute;

  @override
  String get location => GoRouteData.$location(
    '/edit-driver-profile',
    queryParams: {
      if (_self.isMandatory != null)
        'is-mandatory': _self.isMandatory!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $driverShellRoute => StatefulShellRouteData.$route(
  factory: $DriverShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/driver-home',
          hasOverriddenOnExit: false,
          factory: $DriverHomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/my-rides',
          hasOverriddenOnExit: false,
          factory: $DriverRidesRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/notifications',
          hasOverriddenOnExit: false,
          factory: $NotificationsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $DriverShellRouteExtension on DriverShellRoute {
  static DriverShellRoute _fromState(GoRouterState state) => DriverShellRoute();
}

mixin $DriverHomeRoute on GoRouteData {
  static DriverHomeRoute _fromState(GoRouterState state) => DriverHomeRoute();

  @override
  String get location => GoRouteData.$location('/driver-home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DriverRidesRoute on GoRouteData {
  static DriverRidesRoute _fromState(GoRouterState state) => DriverRidesRoute();

  @override
  String get location => GoRouteData.$location('/my-rides');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NotificationsRoute on GoRouteData {
  static NotificationsRoute _fromState(GoRouterState state) =>
      NotificationsRoute();

  @override
  String get location => GoRouteData.$location('/notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sendReportRoute => GoRouteData.$route(
  path: '/send-report',
  hasOverriddenOnExit: false,
  factory: $SendReportRoute._fromState,
);

mixin $SendReportRoute on GoRouteData {
  static SendReportRoute _fromState(GoRouterState state) => SendReportRoute(
    userId: int.parse(state.uri.queryParameters['user-id']!),
    rideId: _$convertMapValue(
      'ride-id',
      state.uri.queryParameters,
      int.tryParse,
    ),
  );

  SendReportRoute get _self => this as SendReportRoute;

  @override
  String get location => GoRouteData.$location(
    '/send-report',
    queryParams: {
      'user-id': _self.userId.toString(),
      if (_self.rideId != null) 'ride-id': _self.rideId!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $myReportsRoute => GoRouteData.$route(
  path: '/my-reports',
  hasOverriddenOnExit: false,
  factory: $MyReportsRoute._fromState,
);

mixin $MyReportsRoute on GoRouteData {
  static MyReportsRoute _fromState(GoRouterState state) => MyReportsRoute();

  @override
  String get location => GoRouteData.$location('/my-reports');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $reportDetailsRoute => GoRouteData.$route(
  path: '/report-details',
  hasOverriddenOnExit: false,
  factory: $ReportDetailsRoute._fromState,
);

mixin $ReportDetailsRoute on GoRouteData {
  static ReportDetailsRoute _fromState(GoRouterState state) =>
      ReportDetailsRoute($extra: state.extra as ReportDataModel);

  ReportDetailsRoute get _self => this as ReportDetailsRoute;

  @override
  String get location => GoRouteData.$location('/report-details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $resetPasswordRoute => GoRouteData.$route(
  path: '/reset-password',
  hasOverriddenOnExit: false,
  factory: $ResetPasswordRoute._fromState,
);

mixin $ResetPasswordRoute on GoRouteData {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      ResetPasswordRoute(resetToken: state.uri.queryParameters['reset-token']!);

  ResetPasswordRoute get _self => this as ResetPasswordRoute;

  @override
  String get location => GoRouteData.$location(
    '/reset-password',
    queryParams: {'reset-token': _self.resetToken},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
  path: '/forgot-password',
  hasOverriddenOnExit: false,
  factory: $ForgotPasswordRoute._fromState,
);

mixin $ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      ForgotPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgot-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $riderShellRoute => StatefulShellRouteData.$route(
  factory: $RiderShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/rider-home',
          hasOverriddenOnExit: false,
          factory: $RiderHomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/rider-rides',
          hasOverriddenOnExit: false,
          factory: $RiderRidesRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/rider-notifications',
          hasOverriddenOnExit: false,
          factory: $RiderNotificationsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/rider-settings',
          hasOverriddenOnExit: false,
          factory: $RiderSettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $RiderShellRouteExtension on RiderShellRoute {
  static RiderShellRoute _fromState(GoRouterState state) => RiderShellRoute();
}

mixin $RiderHomeRoute on GoRouteData {
  static RiderHomeRoute _fromState(GoRouterState state) => RiderHomeRoute();

  @override
  String get location => GoRouteData.$location('/rider-home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RiderRidesRoute on GoRouteData {
  static RiderRidesRoute _fromState(GoRouterState state) => RiderRidesRoute();

  @override
  String get location => GoRouteData.$location('/rider-rides');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RiderNotificationsRoute on GoRouteData {
  static RiderNotificationsRoute _fromState(GoRouterState state) =>
      RiderNotificationsRoute();

  @override
  String get location => GoRouteData.$location('/rider-notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RiderSettingsRoute on GoRouteData {
  static RiderSettingsRoute _fromState(GoRouterState state) =>
      RiderSettingsRoute();

  @override
  String get location => GoRouteData.$location('/rider-settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $walletRoute => GoRouteData.$route(
  path: '/wallet',
  hasOverriddenOnExit: false,
  factory: $WalletRoute._fromState,
);

mixin $WalletRoute on GoRouteData {
  static WalletRoute _fromState(GoRouterState state) => WalletRoute();

  @override
  String get location => GoRouteData.$location('/wallet');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chargeWalletRoute => GoRouteData.$route(
  path: '/charge-wallet',
  hasOverriddenOnExit: false,
  factory: $ChargeWalletRoute._fromState,
);

mixin $ChargeWalletRoute on GoRouteData {
  static ChargeWalletRoute _fromState(GoRouterState state) =>
      ChargeWalletRoute(method: state.uri.queryParameters['method']);

  ChargeWalletRoute get _self => this as ChargeWalletRoute;

  @override
  String get location => GoRouteData.$location(
    '/charge-wallet',
    queryParams: {if (_self.method != null) 'method': _self.method},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $transactionHistoryRoute => GoRouteData.$route(
  path: '/transaction-history',
  hasOverriddenOnExit: false,
  factory: $TransactionHistoryRoute._fromState,
);

mixin $TransactionHistoryRoute on GoRouteData {
  static TransactionHistoryRoute _fromState(GoRouterState state) =>
      TransactionHistoryRoute();

  @override
  String get location => GoRouteData.$location('/transaction-history');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $depositRequestsRoute => GoRouteData.$route(
  path: '/deposit-requests',
  hasOverriddenOnExit: false,
  factory: $DepositRequestsRoute._fromState,
);

mixin $DepositRequestsRoute on GoRouteData {
  static DepositRequestsRoute _fromState(GoRouterState state) =>
      DepositRequestsRoute();

  @override
  String get location => GoRouteData.$location('/deposit-requests');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchRideFormRoute => GoRouteData.$route(
  path: '/search-ride-form',
  hasOverriddenOnExit: false,
  factory: $SearchRideFormRoute._fromState,
);

mixin $SearchRideFormRoute on GoRouteData {
  static SearchRideFormRoute _fromState(GoRouterState state) =>
      SearchRideFormRoute();

  @override
  String get location => GoRouteData.$location('/search-ride-form');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchResultsRoute => GoRouteData.$route(
  path: '/search-results',
  hasOverriddenOnExit: false,
  factory: $SearchResultsRoute._fromState,
);

mixin $SearchResultsRoute on GoRouteData {
  static SearchResultsRoute _fromState(GoRouterState state) =>
      SearchResultsRoute(
        fromCity: state.uri.queryParameters['from-city'],
        toCity: state.uri.queryParameters['to-city'],
      );

  SearchResultsRoute get _self => this as SearchResultsRoute;

  @override
  String get location => GoRouteData.$location(
    '/search-results',
    queryParams: {
      if (_self.fromCity != null) 'from-city': _self.fromCity,
      if (_self.toCity != null) 'to-city': _self.toCity,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $driverReservationsRoute => GoRouteData.$route(
  path: '/driver-reservations',
  hasOverriddenOnExit: false,
  factory: $DriverReservationsRoute._fromState,
);

mixin $DriverReservationsRoute on GoRouteData {
  static DriverReservationsRoute _fromState(GoRouterState state) =>
      DriverReservationsRoute();

  @override
  String get location => GoRouteData.$location('/driver-reservations');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
