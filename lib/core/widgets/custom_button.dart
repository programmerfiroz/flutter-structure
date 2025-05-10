import 'package:flutter/material.dart';
import '../constants/dimensions.dart';
import '../theme/app_colors.dart';

enum ButtonStyleType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ButtonStyleType buttonType;
  final Color? borderColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonType = ButtonStyleType.filled,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? Dimensions.radius8);
    final baseStyle = ButtonStyle(
      padding: MaterialStateProperty.all(
        padding ?? EdgeInsets.symmetric(vertical: Dimensions.height15),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: radius),
      ),
    );

    final buttonStyle = _getButtonStyle(baseStyle);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? Dimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: Dimensions.width10),
            ],
            Flexible(
              child: Text(
                text,
                style: textStyle ??
                    TextStyle(
                      color: _getTextColor(),
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: Dimensions.width10),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }

  /// Return text color based on type
  Color _getTextColor() {
    if (textColor != null) return textColor!;
    switch (buttonType) {
      case ButtonStyleType.outlined:
      case ButtonStyleType.text:
        return AppColors.primaryColor;
      case ButtonStyleType.filled:
      default:
        return Colors.white;
    }
  }

  /// Returns button style based on button type
  ButtonStyle _getButtonStyle(ButtonStyle baseStyle) {
    switch (buttonType) {
      case ButtonStyleType.outlined:
        return baseStyle.copyWith(
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => Colors.transparent,
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: borderColor ?? AppColors.primaryColor, width: 1.5),
          ),
          foregroundColor: MaterialStateProperty.all(
            textColor ?? AppColors.primaryColor,
          ),
        );

      case ButtonStyleType.text:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          foregroundColor: MaterialStateProperty.all(
            textColor ?? AppColors.primaryColor,
          ),
        );

      case ButtonStyleType.filled:
      default:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(MaterialState.disabled)) {
                return (backgroundColor ?? AppColors.primaryColor).withOpacity(0.6);
              }
              return backgroundColor ?? AppColors.primaryColor;
            },
          ),
          foregroundColor: MaterialStateProperty.all(
            textColor ?? Colors.white,
          ),
        );
    }
  }
}
