import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar _buildSnackBar({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    double maxWidth = 500,
  }) {
    return SnackBar(
      content: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(
            message,
            style: TextStyle(color: textColor ?? AppColors.white),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    );
  }

  static SnackBar info(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.lightBlue,
      textColor: AppColors.white,
      maxWidth: maxWidth,
    );
  }

  static SnackBar success(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.successGreen,
      textColor: AppColors.white,
      maxWidth: maxWidth,
    );
  }

  static SnackBar error(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.errorRed,
      textColor: AppColors.white,
      maxWidth: maxWidth,
    );
  }

  static SnackBar warning(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.warningOrange,
      textColor: AppColors.white,
      maxWidth: maxWidth,
    );
  }
}
