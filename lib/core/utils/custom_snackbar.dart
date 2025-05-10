import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomSnackbar {
  static void showSuccess(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.successColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.errorColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showInfo(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.infoColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warningColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }
}