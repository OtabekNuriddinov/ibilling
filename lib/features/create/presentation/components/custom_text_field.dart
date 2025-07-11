import 'package:flutter/material.dart';
import 'package:ibilling/features/contracts/presentation/barrel.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool hasInfo;
  final String? label;
  final String? hintText;
  final VoidCallback? onInfoTap;
  final String? Function(String?)? validator;
  final String? errorText;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.hasInfo = false,
    this.label,
    this.hintText,
    this.onInfoTap,
    this.validator,
    this.errorText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      style: AppTextStyles.textFieldTextStyle.copyWith(
        color: AppColors.white1,
      ),
      keyboardType: keyboardType,
      cursorColor: AppColors.white1,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.black,
        hintStyle: AppTextStyles.textFieldTextStyle.copyWith(
          color: AppColors.white1.withOpacity(0.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.white1, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.white1, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 0.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
