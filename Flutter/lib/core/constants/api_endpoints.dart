class ApiEndpoints {
  const ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://api.atareeqak.tech/api';

  // Users
  static const String users = '/users';

  static const String create = '/create/';
  static const String verifyEmail = '/verify_email/';
  static const String resendVerification = '/resend-verification/';
  static const String login = '/login/';
  static const String forgotPassword = '/forgot_password/';
  static const String verifyResetCode = '/verify_reset_code/';
  static const String resetPassword = '/reset_password/';
  static const String logout = '/logout/';
}