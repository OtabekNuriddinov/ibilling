import '../barrel.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate, 
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(2020),
    lastDate: lastDate ?? DateTime(2030),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.lightGreen,
            onPrimary: Colors.white,
            surface: AppColors.dark,
            onSurface: Colors.white,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.darkest,
          ),
        ),
        child: child!,
      );
    },
  );
}
