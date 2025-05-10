import '../../constants/app_constants.dart';
import 'shared_prefs.dart';

class TokenManager {
  static String getToken() {
    return SharedPrefs.getString(AppConstants.token) ?? '';
  }

  static void saveToken(String token) {
    SharedPrefs.setString(AppConstants.token, token);
  }

  static void clearToken() {
    SharedPrefs.remove(AppConstants.token);
  }
}