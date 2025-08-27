import '../services/config/env_config.dart';

class AppConstants {
  static String appName = EnvConfig.appName;
  static String baseUrl = EnvConfig.baseUrl;
  static const String fontFamily = 'Poppins';
  static const String defaultTag = 'PCB_APP';

  // API base URLs
  static  String imageUrl = '$baseUrl';

  // API endpoints
  static const String userSignupUrl = '/api/user_signup';
  static const String userLoginUrl = '/api/user_login';
  static const String otpVerifyUrl = '/api/otp_verify';

  // Shared Preferences keys
  static const String theme = 'theme';
  static const String language = 'language';
  static const String token = 'token';
  static const String userData = 'user_data';
  static const String isLoggedIn = 'is_logged_in';
}
