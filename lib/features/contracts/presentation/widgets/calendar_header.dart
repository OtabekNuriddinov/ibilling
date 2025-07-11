import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ibilling/core/theme/app_colors.dart';
import 'package:ibilling/core/theme/app_text_styles.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrow;
  final VoidCallback onRightArrow;

  const CalendarHeader({
    super.key,
    required this.focusedDay,
    required this.onLeftArrow,
    required this.onRightArrow,
  });

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.MMMM(context.locale.toString()).format(focusedDay);
    final year = focusedDay.year;
    final header = '$month, $year';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: AppTextStyles.tableCalendarDateStyle,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: AppColors.white5, size: 28),
                onPressed: onLeftArrow,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: AppColors.white5, size: 28),
                onPressed: onRightArrow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
