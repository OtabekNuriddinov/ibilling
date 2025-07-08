import 'package:intl/intl.dart';
import '../barrel.dart';

class DateSelectable extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onPressed;

  const DateSelectable({
    super.key,
    required this.label,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              date != null ? DateFormat('dd.MM.yyyy').format(date!) : label,
              style: AppTextStyles.filterAboveTextStyle.copyWith(
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            Icon(Icons.calendar_month, color: AppColors.white.withAlpha(100), size: 20),
          ],
        ),
      ),
    );
  }
}
