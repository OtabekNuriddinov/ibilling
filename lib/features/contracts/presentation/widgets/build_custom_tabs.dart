import 'package:flutter/material.dart';
import 'package:ibilling/core/theme/app_colors.dart';

class BuildCustomTabs extends StatelessWidget {
  final String text;
  final bool isSelected;
  const BuildCustomTabs({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkGreen : AppColors.dark,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.white2,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Ubuntu',
        ),
      ),
    );
  }
}
