import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.color,
    this.size,
    this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 40,
        height: size ?? 40,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primaryColor,
          strokeWidth: strokeWidth ?? 3,
        ),
      ),
    );
  }

  static Widget fullScreen({Color? color, double? size, double? strokeWidth}) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: LoadingIndicator(
          color: color ?? Colors.white,
          size: size,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }

  static Widget overlay(BuildContext context, {Color? color, double? size, double? strokeWidth}) {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.3,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: LoadingIndicator(
            color: color ?? Colors.white,
            size: size,
            strokeWidth: strokeWidth,
          ),
        ),
      ],
    );
  }
}