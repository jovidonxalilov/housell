class ApiUrls {
  static const String baseUrl = "http://13.51.158.115/docs";

  static const String login = '/auth/login';
  static const String sendOtp = '/auth/send-register-otp';
  static const String verifyOtp = '/auth/verify-register-otp';
  static const String signUp = '/auth/register';
  static const String urlImage = '/upload/image';
  static const String getHouses = '/houses';
  static const String addHouses = '/houses';
  static const String profile = '/users/me';
  static const String patchProfile = '/users';
  static const String senResetOtp = '/auth/send-reset-otp';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String newCompany = '/organization';
  static const String getCompany = '/organization/main';
}
