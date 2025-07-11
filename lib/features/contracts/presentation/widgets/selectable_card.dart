import 'package:flutter/material.dart';
import 'package:ibilling/core/theme/app_text_styles.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_colors.dart';

class SelectableCard extends StatelessWidget {
  final Function() onPressed;
  final int selectedIndex;
  final int currentIndex;
  final String text;
  const SelectableCard({
    super.key,
    required this.onPressed,
    required this.selectedIndex,
    required this.currentIndex,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 110,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: selectedIndex == currentIndex
              ? AppColors.lightGreen
              : AppColors.black,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.cardTextStyle.copyWith(
              color: AppColors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}