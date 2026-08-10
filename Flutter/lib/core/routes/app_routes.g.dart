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
  $riderHomeRoute,
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
  static CheckCodeRoute _fromState(GoRouterState state) =>
      CheckCodeRoute(email: state.uri.queryParameters['email']);

  CheckCodeRoute get _self => this as CheckCodeRoute;

  @override
  String get location => GoRouteData.$location(
    '/check-code',
    queryParams: {if (_self.email != null) 'email': _self.email},
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

RouteBase get $riderHomeRoute => GoRouteData.$route(
  path: '/rider-home',
  hasOverriddenOnExit: false,
  factory: $RiderHomeRoute._fromState,
);

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

RouteBase get $editRideRoute => GoRouteData.$route(
  path: '/edit-ride',
  hasOverriddenOnExit: false,
  factory: $EditRideRoute._fromState,
);

mixin $EditRideRoute on GoRouteData {
  static EditRideRoute _fromState(GoRouterState state) => EditRideRoute();

  @override
  String get location => GoRouteData.$location('/edit-ride');

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
      RideDetailsRoute($extra: state.extra as RideModel);

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
      );

  DriverProfileRoute get _self => this as DriverProfileRoute;

  @override
  String get location => GoRouteData.$location(
    '/driver-profile',
    queryParams: {
      if (_self.isOtherUser != null)
        'is-other-user': _self.isOtherUser!.toString(),
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
  static SendReportRoute _fromState(GoRouterState state) => SendReportRoute();

  @override
  String get location => GoRouteData.$location('/send-report');

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
      ReportDetailsRoute($extra: state.extra as ReportModel);

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
