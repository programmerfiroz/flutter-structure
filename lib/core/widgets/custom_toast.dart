import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomToast {
  static void show(String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = AppColors.primaryColor,
    Color textColor = Colors.white,
    double width = 0.8,
  }) {
    final double screenWidth = Get.width;
    final double toastWidth = screenWidth * width;

    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
      ),
    );

    final Widget overlay = Positioned(
      bottom: 50,
      left: (screenWidth - toastWidth) / 2,
      width: toastWidth,
      child: Material(
        color: Colors.transparent,
        child: toast,
      ),
    );

    final OverlayState? overlayState = Overlay.of(Get.context!);
    final OverlayEntry entry = OverlayEntry(builder: (_) => overlay);

    overlayState?.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
    });
  }

  static void showSuccess(String message) {
    show(message, backgroundColor: AppColors.successColor);
  }

  static void showError(String message) {
    show(message, backgroundColor: AppColors.errorColor);
  }

  static void showWarning(String message) {
    show(message, backgroundColor: AppColors.warningColor);
  }

  static void showInfo(String message) {
    show(message, backgroundColor: AppColors.infoColor);
  }
}