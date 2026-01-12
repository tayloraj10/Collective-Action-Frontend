import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar _buildSnackBar({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    double maxWidth = 200,
  }) {
    return SnackBar(
      content: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(message),
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
      maxWidth: maxWidth,
    );
  }

  static SnackBar success(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.successGreen,
      maxWidth: maxWidth,
    );
  }

  static SnackBar error(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.errorRed,
      maxWidth: maxWidth,
    );
  }

  static SnackBar warning(String message, {double maxWidth = 500}) {
    return _buildSnackBar(
      message: message,
      backgroundColor: AppColors.warningOrange,
      maxWidth: maxWidth,
    );
  }
}
