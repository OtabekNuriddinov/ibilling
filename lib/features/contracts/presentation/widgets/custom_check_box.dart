import 'package:flutter/material.dart';
import 'package:ibilling/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!value),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 5.4.w,
        height: 2.4.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? AppColors.white6 : Colors.white.withAlpha(100),
            width: 1,
          ),
          color: value ? AppColors.white6 : Colors.transparent,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 1.3.h,
            color: value ? Colors.black : Colors.white.withAlpha(100),
          ),
        ),
      ),
    );
  }
}
