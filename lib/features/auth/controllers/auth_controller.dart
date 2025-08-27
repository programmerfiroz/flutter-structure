import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../data/models/user_model.dart';
import '../domain/services/auth_service.dart';
import '../../../routes/route_helper.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController(this._authService);

  final isLoading = false.obs;
  final currentMobile = ''.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    otpController.dispose();
    super.onClose();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      final user = await _authService.getUserInfo();
      if (user != null) {
        currentUser.value = user;
      }
    }
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final user = await _authService.signup(
        nameController.text.trim(),
        mobileController.text.trim(),
      );

      currentUser.value = user;
      currentMobile.value = mobileController.text.trim();

      CustomSnackbar.showSuccess('OTP sent to your mobile number');
      Get.toNamed(RouteHelper.getOtpRoute());
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final user = await _authService.login(
        mobileController.text.trim(),
      );


      currentUser.value = user;
      currentMobile.value = mobileController.text.trim();

      CustomSnackbar.showSuccess('OTP sent to your mobile number');
      Get.toNamed(RouteHelper.getOtpRoute());
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      CustomSnackbar.showError('Please enter OTP');
      return;
    }

    try {
      isLoading.value = true;
      final user = await _authService.verifyOtp(
        currentMobile.value,
        otpController.text.trim(),
      );

      currentUser.value = user;
      otpController.clear();

      CustomSnackbar.showSuccess('OTP verified successfully');
      Get.offAllNamed(RouteHelper.getHomeRoute());
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.clearUserInfo();
      currentUser.value = null;
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }
}
