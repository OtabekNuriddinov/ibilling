import 'package:flutter/material.dart';
import 'package:ibilling/core/theme/app_colors.dart';
import 'package:ibilling/core/theme/app_text_styles.dart';

sealed class AppSnackBar{
  static Future<void> showSnackBar(BuildContext context, String text)async{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.lightGreen,
        content: Text(
          text,
          style: AppTextStyles.noAreMadeTextStyle,
        ),
      ),
    );
  }
}