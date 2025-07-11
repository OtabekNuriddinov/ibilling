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
        width: 116,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Text(
                date != null ? DateFormat('dd.MM.yyyy').format(date!) : label,
                style: AppTextStyles.filterAboveTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.calendar_month, color: AppColors.white.withAlpha(100), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
