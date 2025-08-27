import 'package:hash_code/core/services/storage/token_manger.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage/shared_prefs.dart';
import '../../../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  @override
  Future<UserModel> signup(String name, String mobile) async {
    final response = await _authRepository.signup(name, mobile);

    if (response['res'] == 'success') {
      final user = UserModel.fromJson(response['data']);
      // await saveUserInfo(user);
      return user;
    } else {
      throw Exception(response['msg'] ?? 'Failed to signup');
    }
  }

  @override
  Future<UserModel> login(String mobile) async {
    final response = await _authRepository.login(mobile);

    if (response['res'] == 'success') {
      final user = UserModel.fromJson(response['data']);
      // await saveUserInfo(user);
      return user;
    } else {
      throw Exception(response['msg'] ?? 'Failed to login');
    }
  }

  @override
  Future<UserModel> verifyOtp(String mobile, String otp) async {
    final response = await _authRepository.verifyOtp(mobile, otp);

    if (response['res'] == 'success') {
      // Assuming the token is returned in the response
      if (response['token'] != null && response['token'].isNotEmpty) {
        String userToken = response['token'];
        saveUserToken(userToken);
      }

      final user = UserModel.fromJson(response['data']);
      await saveUserInfo(user);
      await SharedPrefs.setBool(AppConstants.isLoggedIn, true);
      return user;
    } else {
      throw Exception(response['msg'] ?? 'Failed to verify OTP');
    }
  }

  @override
  Future<void> saveUserInfo(UserModel user) async {
    await SharedPrefs.setString(AppConstants.userData, user.toJsonString());
  }

  @override
  Future<void> saveUserToken(String userToken) async {
    TokenManager.saveToken(userToken);
  }

  @override
  Future<void> clearUserInfo() async {
    await SharedPrefs.remove(AppConstants.userData);
     TokenManager.clearToken();
    await SharedPrefs.setBool(AppConstants.isLoggedIn, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return SharedPrefs.getBool(AppConstants.isLoggedIn) ?? false;
  }

  @override
  Future<UserModel?> getUserInfo() async {
    final userJsonString = SharedPrefs.getString(AppConstants.userData);
    return UserModel.fromJsonString(userJsonString);
  }
}
