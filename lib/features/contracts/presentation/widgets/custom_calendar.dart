import 'package:easy_localization/easy_localization.dart';

import '../barrel.dart';

class CustomWeekCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final VoidCallback? onLeftArrow;
  final VoidCallback? onRightArrow;

  const CustomWeekCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    this.onLeftArrow,
    this.onRightArrow,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(6, (i) => focusedDay.add(Duration(days: i)));
    final weekLabels = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...List.generate(days.length, (index) {
            final day = days[index];
            final isSelected = day.year == selectedDay.year &&
                               day.month == selectedDay.month &&
                               day.day == selectedDay.day;
            return Expanded(
              child: GestureDetector(
                onTap: () => onDaySelected(day, focusedDay),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 10.2.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.lightGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: isSelected ? AppColors.white  : AppColors.white.withAlpha(100),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        child: Text(
                          weekLabels[(day.weekday - 1) % 7].tr(),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: AppTextStyles.tableCalendarDateStyle.copyWith(
                          fontSize: 16.sp,
                          color: isSelected ? Colors.white : AppColors.white.withAlpha(100),
                        ),
                        child: Text('${day.day}'),
                      ),
                      SizedBox(height: 0.5.h),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(top: 2),
                        height: 2,
                        width: 24,
                        color: isSelected ? Colors.white : AppColors.white.withAlpha(100),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // Right arrow

        ],
      ),
    );
  }
}
