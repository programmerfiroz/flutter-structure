import 'dart:async';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  @override
  Future<Map<String, dynamic>> signup(String name, String mobile) async {
    final response = await _apiClient.post(
      AppConstants.userSignupUrl,
      data: {
        'name': name,
        'mobile': mobile,
      },
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> login(String mobile) async {
    final response = await _apiClient.post(
      AppConstants.userLoginUrl,
      data: {
        'mobile': mobile,
      },
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    final response = await _apiClient.post(
      AppConstants.otpVerifyUrl,
      data: {
        'mobile': mobile,
        'otp': otp,
      },
    );

    return response.data;
  }
}