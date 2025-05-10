import 'dart:async';

abstract class AuthRepositoryInterface {
  Future<Map<String, dynamic>> signup(String name, String mobile);
  Future<Map<String, dynamic>> login(String mobile);
  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp);
}