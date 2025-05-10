import '../../../../data/models/user_model.dart';

abstract class AuthServiceInterface {
  Future<UserModel> signup(String name, String mobile);
  Future<UserModel> login(String mobile);
  Future<UserModel> verifyOtp(String mobile, String otp);
  Future<void> saveUserToken(String userToken);
  Future<void> saveUserInfo(UserModel user);
  Future<void> clearUserInfo();
  Future<bool> isLoggedIn();
  Future<UserModel?> getUserInfo();
}