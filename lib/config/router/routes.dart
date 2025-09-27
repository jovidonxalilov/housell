class Routes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String map = '/map';
  static const String add = '/add';
  static const String message = '/message';
  static String propertyDetailId(int propertyId) => '/property_detail/$propertyId';
  static String propertyDetail = '/property_detail/:propertyId';
  static const String editProfile = '/edit_profile';
  static const String splash = '/splash';
  static const String profile = '/profile';
  static const String otpVerify = '/otp_verify';
  static const String panorama = '/panorama';
  static const String signUp = '/sign_up';
  static const String resetOtp = '/reset_otp';
  static const String resetOtpVerify = '/reset_otp_verify';
  static const String resetPassword = '/reset_password';
}