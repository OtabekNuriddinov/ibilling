import 'package:flutter/material.dart';
import 'package:ibilling/core/theme/app_colors.dart';

class LanguageOption extends StatelessWidget {
  const LanguageOption({
    super.key,
    required this.selectedLangInDialog,
    required this.currentIndex,
  });

  final int selectedLangInDialog;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.dark,
        shape: BoxShape.circle,
        border: Border.all(
          color: selectedLangInDialog == currentIndex
              ? AppColors.darkGreen : Colors.grey.withAlpha(70),
          width: 3,
        ),
      ),
      child: Center(
        child: selectedLangInDialog == currentIndex
            ? Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            shape: BoxShape.circle,
          ),
        )
            : Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(70),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}